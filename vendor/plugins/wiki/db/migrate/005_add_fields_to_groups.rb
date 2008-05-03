class AddFieldsToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :wiki_requires_approval, :boolean, :default => false
    add_column :groups, :wiki_requires_login_to_post, :boolean, :default => true
    add_column :groups, :disable_wiki_teh, :boolean, :default => false
  end

  def self.down
    remove_column :groups, :wiki_requires_approval
    remove_column :groups, :wiki_requires_login_to_post
    remove_column :groups, :disable_wiki_teh
  end
end
