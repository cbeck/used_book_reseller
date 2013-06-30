class CreateProductImages < ActiveRecord::Migration
  def self.up
    remove_column :products, :image_url
    add_column :products, :image, :binary, :size => 10_000_000
    
    # stuff from generator
    #create_table :product_images do |t|
      #t.column :data, :binary, :size => 10_000_000, :null => false     
    #end
    execute "ALTER TABLE `products` MODIFY `image` MEDIUMBLOB"
  end

  def self.down
    remove_column :products, :image
    add_column :products, :image_url, :string
  end
end
