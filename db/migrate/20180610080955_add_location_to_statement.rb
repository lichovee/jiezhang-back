class AddLocationToStatement < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :location, :text
    add_column :statements, :nation, :string
    add_column :statements, :province, :string
    add_column :statements, :city, :string
    add_column :statements, :district, :string
    add_column :statements, :street, :string
  end
end
