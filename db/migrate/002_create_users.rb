class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  "identity_url"
      t.boolean "admin"
      t.string  "email"
      t.string  "token"
      t.string  "login"
    end
  end

  def self.down
    drop_table :users
  end
end
