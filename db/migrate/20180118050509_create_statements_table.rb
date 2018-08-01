class CreateStatementsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :asset_id
      t.decimal :amount, precision: 12, scale: 2
      t.integer :type
      t.text  :description
      
      t.integer :year
      t.integer :month
      t.integer :day
      t.timestamps
    end
  end
end
