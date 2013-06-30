class AddForeignKeysToReferenceTables < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    foreign_key(:accounts, :user_id, :users)
    foreign_key(:product_images, :product_id, :products)     
  end

  def self.down
    # none - need the keys
  end
end
