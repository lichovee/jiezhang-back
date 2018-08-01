class CreateCategoriesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.integer :user_id
      t.string :name
      t.integer :parent_id
      t.integer :order
      t.string :icon_path
      t.string :color

      t.timestamps
    end
  end
end
