class CreateProductImagesAndFixProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :data
    
    create_table :product_images do |t|
      t.column :data, :binary, :size => 10_000_000, :null => false     
    end
    execute "ALTER TABLE `product_images` MODIFY `data` MEDIUMBLOB"
  end

  def self.down
    # one way - needed for flex image to work and don't want to always transfer image with product model
  end
end
