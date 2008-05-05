class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "flags", :force => true do |t|
      t.integer :flaggable_id
      t.string  :flaggable_type
      t.integer :owner_id
      t.string :owner_type
      t.integer :flagger_id
      t.string  :flagger_type
      t.string  :reason
      t.timestamps
    end
    # todo: add index on reason
    # todo: add index on user_id
    # todo: add index on flaggable_user_id
  end

  def self.down
    drop_table "flags"
  end
end
