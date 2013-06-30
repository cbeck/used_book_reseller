class AddFormatsPubsToProducts < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    add_column "products", "item_format_id", :integer
    add_column "products", "publisher_id", :integer
    
    foreign_key(:products, :item_format_id, :item_formats)
    foreign_key(:products, :publisher_id, :publishers)    
  end

  def self.down
    remove_column "products", "item_format_id"
    remove_column "products", "publisher_id"
  end
end
