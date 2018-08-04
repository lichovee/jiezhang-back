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
		data = []
		(1..13).each do |num|
			data << {id: num, name: "封面-#{num}", val: "default-#{num}.jpeg", path: "../../public/images/covers/default-#{num}.jpeg" }
		end
		render_success data: data
	end

	def set_cover
		current_user.update_attribute(:bg_avatar_url, params[:path])
		render_success
	end
end
