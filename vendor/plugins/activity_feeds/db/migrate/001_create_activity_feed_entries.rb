class CreateActivityFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :activity_feed_entries do |t|
      t.integer :profile_id
      t.string :entry

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_feed_entries
  end
end
