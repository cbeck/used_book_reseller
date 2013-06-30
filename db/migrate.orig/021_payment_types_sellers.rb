require 'migration_helpers'

class PaymentTypesSellers < ActiveRecord::Migration
 
  extend MigrationHelpers
  
  def self.up
    create_table :payment_types_sellers, :id => false do |t|
      t.column :payment_type_id, :integer, :null => false 
      t.column :seller_id, :integer, :null => false           
    end
    
    foreign_key(:payment_types_sellers, :payment_type_id, :payment_types)    
    foreign_key(:payment_types_sellers, :seller_id, :sellers)
    
  end

  def self.down
    drop_table :payment_types_sellers
  end
end