class AddTimeToStatement < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :time, :time
  end
end
