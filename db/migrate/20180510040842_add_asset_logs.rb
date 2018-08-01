class AddAssetLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :asset_logs do |t|
      t.integer :user_id
      t.integer :type
      t.integer :from
      t.integer :to
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :residue, precision: 12, scale: 2
      t.text  :description

      t.timestamps
    end
  end
end
