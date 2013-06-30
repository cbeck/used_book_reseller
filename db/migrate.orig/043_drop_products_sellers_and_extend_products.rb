class DropProductsSellersAndExtendProducts < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    drop_table :products_sellers
    add_column :products, :seller_id, :integer
    
    foreign_key(:products, :seller_id, :sellers)    
  end

  def self.down
    remove_column :products, :seller_id
  end
end
