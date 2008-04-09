class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :requester_id
      t.integer :requested_id
      t.integer :approved

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
