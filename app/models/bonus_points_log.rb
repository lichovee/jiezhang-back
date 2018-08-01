class BonusPointsLog < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :user
  STATEMENT = 1
  SIGN = 2

  TYPE = {
    statement: STATEMENT,
    sign: SIGN
  }

  def self.update_user_points(user, type)
    local_time = Time.now
    today_points_sum = user.bonus_points_logs.where(
      type: type,
      year: local_time.year,
      month: local_time.month, 
      day: local_time.day).sum(:point)
    if today_points_sum.to_i <= 30
      user.bonus_points_logs.create(
        type: type,
        year: local_time.year,
        month: local_time.month,
        day: local_time.day,
        point: 5)
      user.update_attributes(bonus_points: user.bonus_points + 5)
    end
  end
end
