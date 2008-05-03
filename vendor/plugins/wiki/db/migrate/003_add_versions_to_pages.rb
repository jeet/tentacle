class AddVersionsToPages < ActiveRecord::Migration
  def self.up
    Page.create_versioned_table
  end

  def self.down
    # TODO: This doesn't work.  PDI.
    # Page.drop_versioned_table
    
    drop_table :page_versions
  end
end
