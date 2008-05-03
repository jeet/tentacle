class PageGroupFk < ActiveRecord::Migration
  def self.up
    add_column :pages, :group_id, :integer
    add_column :page_versions, :group_id, :integer
    Page.update_all 'group_id=1'
  end

  def self.down
    remove_column :pages, :group_id
    remove_column :page_versions, :group_id
  end
end
