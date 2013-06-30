require 'migration_helpers'

class OrdersSellers < ActiveRecord::Migration
 
  extend MigrationHelpers
  
  def self.up
    create_table :orders_sellers, :id => false do |t|
      t.column :order_id, :integer, :null => false 
      t.column :seller_id, :integer, :null => false           
    end
    
    foreign_key(:orders_sellers, :order_id, :orders)
    foreign_key(:orders_sellers, :seller_id, :sellers)
    
  end

  def self.down
    drop_table :orders_sellers
  end
end