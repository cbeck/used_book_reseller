class RemovePublisherId < ActiveRecord::Migration
  def self.up 
    Product.update_all("publisher_id = NULL")
    execute "ALTER TABLE `products` DROP FOREIGN KEY `fk_products_publisher_id`"   
    remove_column :products, :publisher_id
  end

  def self.down
    add_column :products, :publisher_id, :integer
    foreign_key(:products, :publisher_id, :publishers)  
  end
end
