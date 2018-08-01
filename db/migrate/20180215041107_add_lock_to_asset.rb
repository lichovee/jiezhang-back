class AddLockToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :type, :string, default: 'deposit'
    add_column :assets, :lock, :int, default: 0

    add_column :categories, :lock, :int, default: 0
  end
end
