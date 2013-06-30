class FixProductImageProblems < ActiveRecord::Migration
  def self.up
    #add_column :product_images, :product_id, :integer
    
    #drop_table :products_product_images
    #drop_table :product_images_products
    #drop_table :images_products
    #drop_table :images
    
  end

  def self.down
    # clean up required due to stupidity - time to stop overthinking
    remove_column :product_images, :product_id
  end
end
