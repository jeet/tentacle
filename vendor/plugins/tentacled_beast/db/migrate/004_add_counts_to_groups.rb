class AddCountsToGroups  < ActiveRecord::Migration
  def self.up
    add_column :groups, "topics_count", :integer,  :default => 0
    add_column :groups, "users_count", :integer,  :default => 0
    add_column :groups, "posts_count", :integer,  :default => 0
  end
  
  def self.down
    remove_column :groups, "topics_count", :integer
    remove_column :groups, "users_count", :integer
    remove_column :groups, "posts_count", :integer
  end
end