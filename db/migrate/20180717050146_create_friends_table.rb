class CreateFriendsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :target_id
      t.string  :remark
      t.integer :active, default: 0
      t.timestamps
    end
  end
end
