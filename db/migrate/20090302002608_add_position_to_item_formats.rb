class AddPositionToItemFormats < ActiveRecord::Migration
  def self.up
    change_table :item_formats do |t|
      t.integer :position
    end
  end

  def self.down
    change_table :item_formats do |t|
      t.remove :position
    end
  end
end
