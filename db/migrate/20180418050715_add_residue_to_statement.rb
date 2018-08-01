class AddResidueToStatement < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :residue, :decimal, precision: 12, scale: 2, default: 0
  end
end
