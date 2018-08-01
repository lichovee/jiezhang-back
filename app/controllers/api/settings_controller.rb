class Api::SettingsController < Api::ApiController

	def index; end

	def feedback
		content = params[:content]
		type = params[:type].to_i
		if content.blank?
			return render json: { status: 404, msg: '内容不能为空' }
		end
		
		feedback = current_user.feedbacks.new(content: content, type: type)
		feedback.save!
		render_success
	end

	def covers
		data = [
			{id: 1, name: '默认封面', val: 'default-1.jpeg', path: "#{Settings.host}/default-1.jpeg"},
			{id: 2, name: '封面-01', val: 'default-2.jpeg',  path: "#{Settings.host}/default-2.jpeg"},
			{id: 3, name: '封面-02', val: 'default-3.jpeg',  path: "#{Settings.host}/default-3.jpeg"},
			{id: 4, name: '封面-03', val: 'default-4.jpeg',  path: "#{Settings.host}/default-4.jpeg"}
		]
		render_success data: data
	end

	def set_cover
		current_user.update_attribute(:bg_avatar_url, params[:path])
		render_success
	end
end
