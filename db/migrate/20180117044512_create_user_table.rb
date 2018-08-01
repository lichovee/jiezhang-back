class CreateUserTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :theme_id
      t.string :openid, null: false, unique: true
      t.string :position

      t.timestamps
    end
    add_index :users, :openid, unique: true
  end
end
