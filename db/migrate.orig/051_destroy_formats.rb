class DestroyFormats < ActiveRecord::Migration
  def self.up
    drop_table "formats_products"
    drop_table "formats"    
  end

  def self.down
  end
end
