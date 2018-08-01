class CreateAssetsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.integer :user_id
      t.string :name
      t.decimal :amount, precision: 12, scale: 2

      t.timestamps
    end
  end
end
