class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.column :name, :string
      t.column :being_id, :integer
    end
  end

  def self.down
    drop_table :properties
  end
end
