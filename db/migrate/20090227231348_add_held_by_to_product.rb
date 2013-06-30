class AddHeldByToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :held_by, :integer
  end

  def self.down
    remove_column :products, :held_by
  end
end
