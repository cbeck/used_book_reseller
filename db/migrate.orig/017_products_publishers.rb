require 'migration_helpers'

class ProductsPublishers < ActiveRecord::Migration
 
  extend MigrationHelpers
  
  def self.up
    create_table :products_publishers, :id => false do |t|
      t.column :product_id, :integer, :null => false
      t.column :publisher_id, :integer, :null => false
    end
    
    foreign_key(:products_publishers, :product_id, :products)
    foreign_key(:products_publishers, :publisher_id, :publishers)
  end

  def self.down
    drop_table :products_publishers
  end
end
