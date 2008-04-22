class AddTopicsCountToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :topics_count, :integer, :default => 0
  end

  def self.down
    remove_column :groups, :topics_count
  end
end
