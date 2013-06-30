class ChangePublisherIdToText < ActiveRecord::Migration
  def self.up
    add_column :products, :publisher_name, :string
  end

  def self.down
    remove_column :products, :publisher_name
  end
end
