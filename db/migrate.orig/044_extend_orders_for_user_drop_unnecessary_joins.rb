class ExtendOrdersForUserDropUnnecessaryJoins < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    add_column :orders, :user_id, :integer
    
    drop_table :orders_users
    drop_table :orders_sellers
    
    foreign_key(:orders, :user_id, :users) 
  end

  def self.down
    remove_column :orders, :user_id
  end
end
