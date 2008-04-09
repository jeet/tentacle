class CreateBeings < ActiveRecord::Migration
  def self.up
    create_table :beings do |t|
      t.column :country, :string
      t.column :race, :string
      t.column :type, :string
    end
  end

  def self.down
    drop_table :beings
  end
end
