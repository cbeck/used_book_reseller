class OrderUpdate < ActiveRecord::Migration
  def self.up
    add_column :orders, :purchased_at, :datetime
  end

  def self.down
    remove_column :orders, :purchased_at
  end
end
