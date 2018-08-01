class AddUserAsset < ActiveRecord::Migration[5.1]
  def change
    remove_column :assets, :user_id
    add_column :categories, :budget, :decimal, precision: 12, scale: 2, default: 0
    create_table :users_assets do |t|
      t.integer :user_id
      t.string :asset_id
      t.timestamps
    end
  end
end
