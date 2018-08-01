class AddCategoryParentId < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :type, :string
    add_column :assets, :parent_id, :int, :default => 0
  end
end
