require 'migration_helpers'

class CreateOrdersUsers < ActiveRecord::Migration

  extend MigrationHelpers
  
  def self.up
    create_table :orders_users, :id => false do |t|
      t.column :order_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    
    foreign_key(:orders_users, :order_id, :orders)
    
  end

  def self.down
    drop_table :orders_users
  end
end
