class AddAddressToPreOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :pre_orders, :address, :string
  end
end
