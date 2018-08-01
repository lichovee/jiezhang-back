class AddBudgetToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :budget, :decimal, precision: 12, scale: 2, default: 0
  end
end
