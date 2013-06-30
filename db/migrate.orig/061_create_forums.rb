class CreateForums < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :forums do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :description, :text
      t.column :created_at, :timestamp
    end
    
     
  end

  def self.down
    drop_table :forums
  end
end
