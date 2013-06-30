class CreateProductProductImages < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table "products_product_images", :id => false, :force => true do |t|
       t.column :product_id,         :integer
       t.column :product_image_id,   :integer     
    end

    foreign_key(:products_product_images, :product_id, :products)
    foreign_key(:products_product_images, :product_image_id, :product_images)    
    
  end

  def self.down
    drop_table :products_product_images
  end
end
