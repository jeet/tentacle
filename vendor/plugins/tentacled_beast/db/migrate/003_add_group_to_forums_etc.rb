class AddGroupToForumsEtc  < ActiveRecord::Migration
  def self.up
    add_column :forums, "group_id", :integer
    add_column :posts, "group_id", :integer
    add_column :topics, "group_id", :integer
  end
  
  def self.down
    remove_column :forums, "group_id", :integer
    remove_column :posts, "group_id", :integer
    remove_column :topics, "group_id", :integer
  end
end