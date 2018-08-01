class UidDefaultZero < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :uid, :int, default: 0
  end
end
