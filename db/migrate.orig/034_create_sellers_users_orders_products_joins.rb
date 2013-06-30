class CreateSellersUsersOrdersProductsJoins < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :sellers_users, :id => false do |t|
      t.column :seller_id, :integer, :null => false
      t.column :user_id, :integer, :null => false      
    end
    
    create_table :products_sellers, :id => false do |t|
      t.column :product_id, :integer, :null => false
      t.column :seller_id, :integer, :null => false      
    end
    
    create_table :orders_users, :id => false do |t|
      t.column :order_id, :integer, :null => false
      t.column :user_id, :integer, :null => false      
    end
    
    foreign_key(:sellers_users, :seller_id, :sellers)
    foreign_key(:sellers_users, :user_id, :users)
    
    foreign_key(:products_sellers, :product_id, :products)
    foreign_key(:products_sellers, :seller_id, :sellers)
    
    foreign_key(:orders_users, :order_id, :orders)
    foreign_key(:orders_users, :user_id, :users)    
    
  end

  def self.down
    drop_table :sellers_users
    drop_table :products_sellers
    drop_table :orders_users
  end
end
