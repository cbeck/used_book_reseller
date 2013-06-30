class AddHoldToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :held_at, :datetime
  end

  def self.down
    remove_column :products, :held_at
  end
end
