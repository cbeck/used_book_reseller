class AddPositionToProductImages < ActiveRecord::Migration
  def self.up
    change_table :product_images do |t|
      t.integer :position
    end
  end

  def self.down
    change_table :product_images do |t|
      t.remove :position
    end
  end
end
