class AddTitleToStatement < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :title, :string
  end
end
