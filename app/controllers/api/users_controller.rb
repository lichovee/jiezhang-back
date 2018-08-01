class Api::UsersController < Api::ApiController
  
  def index; end
  
  def update_user
    user = params.require(:user)
    user_params = user.permit(:country, :city, :gender, :language, :province)
    user_params.delete(:openid)
    user_params.merge!(nickname: strip_emoji(user[:nickName]), remote_avatar_url_url: user[:avatarUrl])
    current_user.update_attributes!(user_params)
    render_success
  end

  private

  def strip_emoji(text)
		text = text.force_encoding('utf-8').encode
		text.gsub!(/[\u{1f300}-\u{1f5ff}]/, '')
    text.gsub!(/[\u{25FF}-\u{2BEF}]/, '')
		text.gsub!(/[\u{1f600}-\u{1f64f}]/, '')
		text.gsub!(/[\u{2702}-\u{27b0}]/, '')
		text.gsub!(/[\u{1f680}-\u{1f6c0}]/, '')
		text.gsub!(/[\u{1f910}-\u{1f981}]/, '')
		text.gsub!(/[\u{1f170}-\u{1f251}]/, '')
		text
  end
  
end
