class AddOrderToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :order, :int, default: 0
  end
end
