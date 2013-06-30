class CreateCategoriesProducts < ActiveRecord::Migration
  
  extend MigrationHelpers
  
  def self.up
    create_table "categories_products", :id => false  do |t|
      t.column "category_id", :integer, :null => false
      t.column "product_id", :integer, :null => false
    end
    
    foreign_key(:categories_products, :category_id, :categories)
    foreign_key(:categories_products, :product_id, :products)
    
  end

  def self.down
    drop_table "categories_products"
  end
end
