class AddMessagingTables < ActiveRecord::Migration
  def self.up
    create_table :private_messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :title
      t.text :body
      t.text :body_html
      t.boolean :sender_deleted, :default => false
      t.boolean :recipient_deleted, :default => false
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    add_index :private_messages, :sender_id
    add_index :private_messages, :recipient_id
  end

  def self.down
    remove_index :private_messages, :sender_id
    remove_index :private_messages, :recipient_id
    drop_table :private_messages
  end
end