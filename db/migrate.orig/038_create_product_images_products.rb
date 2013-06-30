class CreateProductImagesProducts < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table "product_images_products", :id => false, :force => true do |t|
      t.column :product_image_id,   :integer
      t.column :product_id,         :integer
    end

    foreign_key(:product_images_products, :product_image_id, :product_images)    
    foreign_key(:product_images_products, :product_id, :products)
    
  end

  def self.down
    drop_table :product_images_products
  end
end
