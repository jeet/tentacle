class AddLastSeenAtToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :last_seen_at, :datetime
  end

  def self.down
    remove_column :profiles, :last_seen_at
  end
end
