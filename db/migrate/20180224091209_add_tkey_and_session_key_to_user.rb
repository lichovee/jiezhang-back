class AddTkeyAndSessionKeyToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :name
    remove_column :users, :position

    add_column :users, :uid, :integer, null: false, unique: true
    add_column :users, :third_session, :string
  end
end
