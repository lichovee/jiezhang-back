class CreateFriendAppliesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_applies do |t|
      t.integer :source_id
      t.integer :target_id
      t.string  :remark
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
