class Api::StatementsController < Api::ApiController
	before_action :get_statement, only: [:show, :destroy]
	
	def show; end

	def create
		service = StatementsService.new(current_user, params)
		@statement = service.create!
	end

	def update
		service = StatementsService.new(current_user, params)
		@statement = service.update!
		render 'create'
	end

	def destroy
		if @statement.destroy
			render_success
		else
			api_error status: 500, msg: '删除失败'
		end
	end

	# 获取账单详情
	def detail
		@statement = current_user.statements.find_by_id(params[:id])
		return render_404 '账单不存在或已删除' if @statement.blank?
	end

	# 账户选择
	def assets
		@list = current_user.assets.includes(:children).where(parent_id: 0)
		@frequents = @list.where("parent_id > 0 and frequent != 0").order('frequent desc').limit(5)
		render 'list'
  end

	# 分类选择
	def categories
		@list = current_user.categories.includes(:children).where(parent_id: 0, type: params[:type] || 'expend')
		@frequents = @list.where("parent_id > 0 and frequent != 0").order('frequent desc').limit(5)
		render 'list'
	end

	# 猜你想用的分类
	def category_frequent
		@frequents = guess(current_user.categories, true)
		render 'frequent'
	end

	# 猜你想用的资产
	def asset_frequent
		@frequents = guess(current_user.assets)
		render 'frequent'
	end

	private

		def get_statement
			@statement = current_user.statements.find_by_id(params[:id])
			return render_404 unless @statement
		end

		def guess(obj, is_category = false)
			obj = obj.where("parent_id > 0 and frequent >= 3")
			obj = obj.joins(:statements)
							 .where("time(`statements`.created_at) <= :start_time and time(`statements`.created_at) >= :end_time",
												start_time: (Time.now + 1.hour).strftime('%H:%M:%S'),
												end_time: (Time.now - 1.hour).strftime('%H:%M:%S'),
											)
			obj = obj.where("`statements`.type = ?", params[:type] || 'expend') if is_category
			obj.order('frequent desc').limit(3).uniq
		end
end
