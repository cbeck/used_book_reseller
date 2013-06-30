class CreateItemFormatsProducts < ActiveRecord::Migration
  
  extend MigrationHelpers
  
  def self.up
    create_table "item_formats_products", :id => false do |t|
      t.column "item_format_id", :integer, :null => false
      t.column "product_id", :integer, :null => false
    end
    
    foreign_key(:item_formats_products, :item_format_id, :item_formats)
    foreign_key(:item_formats_products, :product_id, :products)
    
  end

  def self.down
    drop_table "item_formats_products"
  end
end
