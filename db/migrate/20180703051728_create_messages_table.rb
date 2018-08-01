class CreateMessagesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :target_id
      t.integer :target_type
      t.text    :content

      t.timestamps
    end
  end
end
