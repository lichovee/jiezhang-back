class AddIndexToCategoryAsset < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :type
    add_index :categories, :order
    add_index :categories, :parent_id

    add_index :assets, :amount
    add_index :assets, :type
    add_index :assets, :parent_id
    add_index :assets, :order
  end
end
