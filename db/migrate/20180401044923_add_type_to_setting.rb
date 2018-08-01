class AddTypeToSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :type, :int, default: 0
  end
end
