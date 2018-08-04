class Message < ApplicationRecord
  belongs_to :target_user, foreign_key: 'target_id', class_name: "User"

  SYSTEM = 0

  def msg_type
    self.target_type == SYSTEM ? '系统消息' : ''
  end
end
