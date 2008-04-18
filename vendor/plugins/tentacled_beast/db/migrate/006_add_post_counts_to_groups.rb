class AddPostCountsToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :posts_count, :integer
  end

  def self.down
    remove_column :groups, :posts_count
  end
end
