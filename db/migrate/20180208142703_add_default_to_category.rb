class AddDefaultToCategory < ActiveRecord::Migration[5.1]
  def change
    change_column :categories, :parent_id, :int, default: 0, null: false
    change_column :categories, :order, :int, default: 0, null: false
    change_column :assets, :amount, :decimal, precision: 12, scale: 2, default: 0, null: false
    change_column :statements, :user_id, :int, null: false
    change_column :statements, :asset_id, :int, null: false
    change_column :statements, :type, :string, null: false
  end
end
