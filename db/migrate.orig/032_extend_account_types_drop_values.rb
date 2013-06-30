class ExtendAccountTypesDropValues < ActiveRecord::Migration
  def self.up
    
    drop_table :account_values
    
    add_column :account_types, :max_monthly_sales, :integer
    add_column :account_types, :max_products, :integer
    add_column :account_types, :commission, :boolean
    add_column :account_types, :flat_fee, :boolean
    add_column :account_types, :private_storefront, :boolean
    add_column :account_types, :allow_paypal, :boolean
    add_column :account_types, :allow_merchant_account, :boolean   
    
  end

  def self.down
    # account values not the right approach
    
    remove_column :account_types, :max_monthly_sales
    remove_column :account_types, :max_products
    remove_column :account_types, :commission
    remove_column :account_types, :flat_fee
    remove_column :account_types, :private_storefront
    remove_column :account_types, :allow_paypal
    remove_column :account_types, :allow_merchant_account   
    
  end
end
