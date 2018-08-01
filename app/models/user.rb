class User < ApplicationRecord
  has_many :statements, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :users_assets, dependent: :destroy
  has_many :assets, through: :users_assets
  has_many :own_assets, foreign_key: :creator_id, dependent: :destroy, class_name: "Asset"
  has_many :bonus_points_logs, dependent: :destroy
  has_many :friends, foreign_key: :user_id, dependent: :destroy, class_name: "Friend"
  has_many :friend_applies, foreign_key: :source_id
  has_many :asset_logs
  has_many :pre_orders, foreign_key: :owner_id
  has_many :feedbacks

  validates :openid, presence: true, uniqueness: true

  mount_uploader :avatar_url, AvatarUploader
  # mount_uploader :bg_avatar_url, AvatarUploader

  include UserAble

  SESSION_KEY_EXPIRE = 7200

  def designation
    bonus[0]
  end

  def designation_bg
    bonus[1]
  end

  def bonus
    points = self.bonus_points.to_i
    points = 0 if points < 0
    return ['钻石会员', '#f14ed8'] if self.id == 547
    if points < 300
      ['初出茅庐', '#FF9C0B']
    elsif points < 600
      ['小有成就', '#FF9C0B']
    elsif points < 1200
      ['游刃有余', '#FF9C0B']
    elsif points < 1800
      ['织梦者', '#FF9C0B']
    elsif points < 3000
      ['风行者', '#FF9C0B']
    else
      ['记账达人', '#FF9C0B']
    end
  end

  def avatar_path
    if self.avatar_url_identifier.present? && self.avatar_url_identifier.include?('http')
      self.avatar_url_identifier
    else
      "#{Settings.host}#{self.avatar_url}"
    end
  end

  def bg_avatar_path
    if self.bg_avatar_url.present?
      "#{Settings.host}#{self.bg_avatar_url}"
    else
      nil
      # "#{Settings.host}/default-bg.jpeg"
    end
  end

  def redis_session_key
    "@user_#{self.id}_session_key@"
  end

  def set_budget?
    !self.budget.zero?
  end

  # 坚持记账天数
  def persist
    self.statements.count("distinct year, month, day")
  end

  # 净资产
  def net_worth
    total_asset - total_liability
  end

  # 总资产
  def total_asset
    self.assets.deposit.sum(:amount)
  end

  # 总负债
  def total_liability
    self.assets.debt.sum(:amount)
  end

  # 昨日结余
  def yesterday_balance
    yesterday = Time.now - 1.day
    yesterday_income = self.statements.income.where('year = ? AND month = ? AND day = ?', yesterday.year, yesterday.month, yesterday.day)
    yesterday_expend = self.statements.expend.where('year = ? AND month = ? AND day = ?', yesterday.year, yesterday.month, yesterday.day)
    yesterday_income = yesterday_income.sum(:amount)
    yesterday_expend = yesterday_expend.sum(:amount)

    yesterday_income.to_f - yesterday_expend.to_f
  end

  # 近七日日均消费
  def last_sevent_day_consumption
    today = Time.now.end_of_day
    sevent_day = (Time.now - 7.day).beginning_of_day
    statements = self.statements.expend.where('created_at >= ? AND created_at <= ?', sevent_day, today)
    consumption = statements.sum(:amount)
    consumption.to_f / 7
  end

  # 近一个月日均消费
  def last_month_consumption
    today = Time.now.end_of_day
    last_month = (Time.now - 1.month).beginning_of_day
    statements = self.statements.expend.where('created_at >= ? AND created_at <= ?', last_month, today)
    consumption = statements.sum(:amount)
    consumption.to_f / 30
  end

end