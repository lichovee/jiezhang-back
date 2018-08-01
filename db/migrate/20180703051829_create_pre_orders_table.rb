class CreatePreOrdersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pre_orders do |t|
      t.integer :owner_id
      t.integer :creator_id
      t.string :name
      t.decimal :amount, precision: 12, scale: 2
      t.string :state, default: 'pending'
      t.text :remark
      t.timestamps
    end
  end
end
