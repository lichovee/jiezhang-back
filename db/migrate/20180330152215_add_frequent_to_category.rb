class AddFrequentToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :frequent, :int, default: 0
  end
end
