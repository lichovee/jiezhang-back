class AddIconPathAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :icon_path, :string
  end
end
