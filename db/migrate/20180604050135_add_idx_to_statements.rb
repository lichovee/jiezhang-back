class AddIdxToStatements < ActiveRecord::Migration[5.1]
  def change
    add_index :statements, [:user_id, :category_id]
    add_index :statements, [:user_id, :asset_id]
    add_index :statements, [:user_id, :type]

    remove_index :statements, :amount
    remove_index :statements, :created_at
  end
end
