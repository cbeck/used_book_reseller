class AddShippingInfoToLineItems < ActiveRecord::Migration
  def self.up
    change_table :line_items do |t|
      t.datetime :shipped_at
      t.string :tracking_number
      t.integer :carrier_id
    end
  end

  def self.down
    change_table :line_items do |t|
      t.remove :shipped_at
      t.remove :tracking_number
      t.remove :carrier_id
    end
  end
end
