class MoveEmailToProfile < ActiveRecord::Migration
  def self.up
    remove_column :users, :email
    add_column :profiles, :email, :string
  end

  def self.down
    remove_column :profiles, :email
    add_column :users, :email
  end
end
