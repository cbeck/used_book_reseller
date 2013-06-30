class AddTimestampsToItems < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.datetime :updated_at
    end
    
    change_table :line_items do |t|
      t.timestamps 
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :updated_at
    end
    
    change_table :line_items do |t|
      t.remove :updated_at
      t.remove :created_at
    end
  end
end
