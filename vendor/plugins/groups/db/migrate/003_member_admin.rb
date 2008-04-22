class MemberAdmin < ActiveRecord::Migration
  def self.up
    add_column :memberships, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :memberships, :admin
  end
end
