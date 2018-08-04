class Api::MessageController < Api::ApiController

  def index
    @messages = current_user.messages.order('created_at desc')
  end

  def show
    @message = current_user.messages.find_by_id(params[:id])
    @message.update_attribute(:already_read, 1) if @message.already_read == 0
  end
  
end
