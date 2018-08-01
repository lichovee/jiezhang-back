class Api::UploadController < Api::ApiController

	def upload
		type = params[:type]
		if type == 'user_avatar'
			current_user.avatar_url = AvatarUploader.new
			current_user.avatar_url.store!(params[:file])
			current_user.save!
			return render json: { status: 200, avatar_path: current_user.avatar_path }
		elsif type == 'bg_avatar'
			current_user.bg_avatar_url = AvatarUploader.new
			current_user.bg_avatar_url.store!(params[:file])
			current_user.save!
			return render json: { status: 200, avatar_path: current_user.bg_avatar_path }
		end
		render_404
	end
end
