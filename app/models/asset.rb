class Asset < ApplicationRecord
  self.inheritance_column = nil
  has_many :statements
  has_many :users_assets, dependent: :destroy
  belongs_to :parent, foreign_key: 'parent_id', class_name: 'Asset', optional: true
  has_many :children, foreign_key: 'parent_id', class_name: 'Asset'
  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'

  before_validation :check_params

  scope :deposit, ->{ where("type = 'deposit' AND parent_id != 0") }
  scope :debt, ->{ where("type = 'debt' AND parent_id != 0") }
  scope :parent_list, ->{ where("parent_id = 0") }

  DEPOSIT = 'deposit'
  DEBT = 'debt'
  
  after_destroy :destroy_parent

  def destroy_parent
    childs_assets = creator.categories.where(parent_id: self.id)
    # 删除分类下的所有账单
    creator.statements.where(asset_id: self.id).destroy_all
    creator.statements.where(asset_id: childs_assets.pluck(:id)).destroy_all
    childs_assets.destroy_all
  end

  def icon_url
    return nil if self.icon_path.blank?
    "#{Settings.host}#{self.icon_path}"
  end
  
  private

  def check_params
    if self.name.empty?
      raise '名称不能为空'
    end
  end

end
