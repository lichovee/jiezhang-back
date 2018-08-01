class AddCreatorIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :creator_id, :int
  end
end
