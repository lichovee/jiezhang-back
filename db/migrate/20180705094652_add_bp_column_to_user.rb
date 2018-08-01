class AddBpColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bonus_points, :int, default: 0
  end
end
