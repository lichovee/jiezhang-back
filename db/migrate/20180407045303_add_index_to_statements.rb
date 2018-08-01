class AddIndexToStatements < ActiveRecord::Migration[5.1]
  def change
    add_index :statements, :type
    add_index :statements, [:year, :month, :day, :time]
    add_index :statements, :amount
    add_index :statements, :created_at
  end
end
