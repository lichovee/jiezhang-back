class Api::FriendController < Api::ApiController
  before_action :get_target_user, only: [:send_apply, :accept_apply, :reject_apply]
  def index
    @friends = current_user.friends
  end

  # 发送申请
  def send_apply
    friend_apply = current_user.friend_applies.find_by(target_id: @target_user.id, status: FriendApply::WAITING)
    return api_error(status: 400, msg: '您的申请已提交，请勿重复申请') if friend_apply.present?
    current_user.friend_applies.create(target_id: @target_user.id)
    render_success '已成功申请添加对方为好友'
  end

  # 接受申请
  def accept_apply
    friend_apply = current_user.friend_applies.find_by(target_id: @target_user.id, status: FriendApply::WAITING)
    if friend_apply.present?

    else

    end
  end

  # 拒绝申请
  def reject_apply
    friend_apply = current_user.friend_applies.find_by(target_id: @target_user.id, status: FriendApply::WAITING)
    if friend_apply.present?
      
    else

    end
  end

  # 设置权限
  def set_ability
  end

  private

    def get_target_user
      target_id = params[:target_id]
      @target_user = User.find_by(uid: target_id)
      return render_404('无效的用户') if @target_user.blank?
      return api_error(status: 400, msg: '对方已是您的好友') if current_user.friends.find_by(target_id: @target_user.id)
    end

end