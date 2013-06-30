class AddStatusToLineItem < ActiveRecord::Migration
  def self.up
    add_column :line_items, :status, :string, :default => 'pending'
  end

  def self.down
    remove_column :line_items, :status
  end
end
