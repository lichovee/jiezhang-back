class Statement < ApplicationRecord
  
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :asset, optional: true
  belongs_to :target_asset, foreign_key: :target_asset_id, class_name: 'Asset', optional: true
  belongs_to :category
  scope :expend, -> { where("`statements`.type = 'expend'") }
  scope :income, -> { where("`statements`.type = 'income'") }
  
  INCOME = 'income'
  EXPEND = 'expend'
  before_create :set_residue
  after_create :after_create_statement
  after_update :update_asset_amount
  after_destroy :destroy_asset

  def destroy_asset
    return if self.asset.blank?
    asset_amount = self.asset.amount
    if self.type == 'expend'
      amount = asset_amount + self.amount
    elsif type == 'income'
      amount = asset_amount - self.amount
    else
      amount = asset_amount + self.amount
      self.target_asset.update_attribute(:amount, self.target_asset.amount - self.amount)
    end
    self.asset.update_attribute(:amount, amount)
  end
  
  def set_residue
    if self.type == 'income'
      self.residue = self.asset.amount + self.amount
    else
      self.residue = self.asset.amount - self.amount
    end
  end

  def after_create_statement
    amount = self.type == 'income' ? self.asset.amount + self.amount : self.asset.amount - self.amount
    category.increment(:frequent, by = 1).save
    asset.increment(:frequent, by = 1).save
    self.asset.update_attribute(:amount, amount)
    if target_asset_id.present? && target_asset.present?
      target_asset.update_attribute(:amount, self.target_asset.amount + self.amount)
    end
    # 更新用户积分
    BonusPointsLog.update_user_points(user, BonusPointsLog::STATEMENT)
  end

  def update_asset_amount
    return if type == 'transfer'
    # 判断收入/支出是否有更改
    type_strs = self.type_change
    if type_strs.nil?
      type_strs = [self.type, self.type]
    end

    # 判断金额是否有变更
    amounts = self.amount_change
    if amounts.nil?
      amounts = [self.amount, self.amount]
    end

    # 判斷賬戶類型是否有變更
    asset_ids = self.asset_id_change
    if asset_ids.present?
      before_asset = Asset.find_by_id(asset_ids.first)
      last_asset = Asset.find_by_id(asset_ids.last)
    end

    before_asset = before_asset || asset
    before_amount = before_asset.amount
    before_amount = type_strs.first == 'expend' ? before_amount + amounts.first : before_amount - amounts.first
    before_asset.update_attribute(:amount, before_amount)

    last_asset = last_asset || before_asset
    after_amount = last_asset.amount
    after_amount = type_strs.last == 'expend' ? after_amount - amounts.last : after_amount + amounts.last
    last_asset.update_attribute(:amount, after_amount)
  end

  def transfer?
    type == 'transfer'
  end

  def date
    Time.parse("#{self.year}-#{self.month}-#{self.day} #{self.time}")
  end

  def hour_s
    Time.parse("#{self.time}").strftime("%H:%M")
  end

  def week
    self.created_at.strftime('%W')
  end
end
