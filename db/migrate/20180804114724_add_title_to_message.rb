class AddTitleToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :title, :string, after: :id
    add_column :messages, :content_type, :string, default: 'md', after: :content
    add_column :messages, :avatar_url, :string, after: :content_type
    add_column :messages, :already_read, :int, default: 0
    add_column :messages, :page_url, :string
    
  end
end
