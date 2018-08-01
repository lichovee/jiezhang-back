class AssetLog < ApplicationRecord
  self.inheritance_column = nil
  
  belongs_to :source, foreign_key: 'from', class_name: 'Asset'
  belongs_to :target, foreign_key: 'to', class_name: 'Asset'
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'

  TRANSFER = 1 # 转账

  def type
    'transfer'
  end

  def date
    self.created_at.strftime("%Y-%m-%d")
  end
end
