require 'migration_helpers'

class SellersUsers < ActiveRecord::Migration
 
  extend MigrationHelpers
  
  def self.up
    create_table :sellers_users, :id => false do |t|
      t.column :seller_id, :integer, :null => false
      t.column :user_id, :integer, :null => false      
    end
    
    foreign_key(:sellers_users, :seller_id, :sellers)
    
    
  end

  def self.down
    drop_table :sellers_users
  end
end