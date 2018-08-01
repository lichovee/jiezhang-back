class Api::ChartController < Api::ApiController
  before_action :statements

  def index
    # 单笔明细
    @singles = @statements.includes(:category, :asset)
    @expend = @statements.expend.sum(:amount)
    @income = @statements.income.sum(:amount)
    # 分类列表
    @categories = @statements.joins("inner join `categories` as c1 on `c1`.id = `statements`.category_id")
                             .joins("inner join `categories` as c2 on `c2`.id = `c1`.parent_id")
                             .group('c2.id')
                             .select('c2.name, c2.id, 1 as hidden')
  end

  # 分类详情
  def spread
    @statements = @statements.includes(:category, :asset).joins(:category).where('`categories`.parent_id = ?', params[:id]).order('statements.created_at desc')
  end

  private

    def statements
      return @statements if @statements.present?
      start_date = Time.parse(params[:start_time]).beginning_of_day
      return render_404 if params[:start_time].blank?

      if params[:end_time].present?
        end_date = Time.parse(params[:end_time]).end_of_day
        @statements = current_user.statements.where('`statements`.created_at >= ? AND `statements`.created_at <= ?', start_date, end_date)
      else
        @statements = current_user.statements.where('`statements`.year = ? and `statements`.month = ? and `statements`.day = ?', start_date.year, start_date.month, start_date.day)
      end
      @statements = @statements.order('`statements`.year desc, `statements`.month desc, `statements`.day desc, `statements`.time desc, `statements`.id desc')
    end

end
