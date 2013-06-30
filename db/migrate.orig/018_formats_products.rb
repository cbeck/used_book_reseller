require 'migration_helpers'

class FormatsProducts < ActiveRecord::Migration
 
  extend MigrationHelpers
  
  def self.up
    create_table :formats_products, :id => false do |t|
      t.column :format_id, :integer, :null => false
      t.column :product_id, :integer, :null => false      
    end
    
    foreign_key(:formats_products, :format_id, :formats)
    foreign_key(:formats_products, :product_id, :products)
    
  end

  def self.down
    drop_table :formats_products
  end
end