class AddRemarkToAsset < ActiveRecord::Migration[5.1]
  def up
    add_column :assets, :remark, :text
  end
end
