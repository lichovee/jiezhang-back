class Category < ApplicationRecord

  self.inheritance_column = nil
  has_many :statements
  belongs_to :user
  belongs_to :parent, foreign_key: 'parent_id', class_name: 'Category', optional: true
  has_many :children, foreign_key: 'parent_id', class_name: 'Category'
  
  scope :expend_childs, ->{ where("parent_id != 0 and type = 'expend'") }
  scope :income_childs, ->{ where("parent_id != 0 and type = 'income'") }
  scope :parent_list, ->{ where("parent_id = 0") }
  
  before_validation :check_params

  after_destroy :destroy_parent

  def destroy_parent
    childs_categories = user.categories.where(parent_id: self.id)
    # 删除分类下的所有账单
    user.statements.where(category_id: self.id).destroy_all
    user.statements.where(category_id: childs_categories.pluck(:id)).destroy_all
    childs_categories.destroy_all
  end

  def is_parent?
    self.parent_id.zero?
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
