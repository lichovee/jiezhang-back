class CreateBonusPointsLog < ActiveRecord::Migration[5.1]
  def change
    create_table :bonus_points_logs do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :type, default: 0
      t.integer :point, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
