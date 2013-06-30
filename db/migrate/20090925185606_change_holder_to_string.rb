class ChangeHolderToString < ActiveRecord::Migration
  def self.up
    remove_column :products, :held_by
    add_column :products, :held_by, :string
  end

  def self.down
    remove_column :products, :held_by
    add_column :products, :held_by, :integer
  end
end
