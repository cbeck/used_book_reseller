class CreateShippingTerms < ActiveRecord::Migration
  def self.up
    create_table :shipping_terms do |t|
      t.string :name
      t.integer :max_ship_time

      t.timestamps
    end
    
    ShippingTerm.create :name => '1-3 days', :max_ship_time => 3
    ShippingTerm.create :name => '3-5 days', :max_ship_time => 5
    ShippingTerm.create :name => '5-7 days', :max_ship_time => 7
    ShippingTerm.create :name => '7-14 days', :max_ship_time => 14
    
  end

  def self.down
    drop_table :shipping_terms
  end
end
