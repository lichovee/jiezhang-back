class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :theme_id, :int, default: 0
    add_column :users, :nickname, :string
    add_column :users, :language, :string
    add_column :users, :city, :string
    add_column :users, :province, :string
    add_column :users, :avatar_url, :string, limit: 512
    add_column :users, :country, :string
    add_column :users, :session_key, :string
    add_column :users, :gender, :int
  end
end
