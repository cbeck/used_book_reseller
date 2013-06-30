class AddMoreMoney < ActiveRecord::Migration
  def self.up
    remove_column :line_items, :total_price
    
    add_column :line_items, :total_cents, :integer, :default=>0
    add_column :line_items, :currency, :string, :limit=>3, :default=>"USD"
    
    remove_column :account_types, :current_price
    remove_column :account_types, :commission
    remove_column :account_types, :flat_fee
    
    add_column :account_types, :price_cents, :integer, :default=>0
    add_column :account_types, :commission_cents, :integer, :default=>0
    add_column :account_types, :flat_fee_cents, :integer, :default=>0
    add_column :account_types, :currency, :string, :limit=>3, :default=>"USD"

    remove_column :products, :offer_currency
    remove_column :products, :retail_currency    
    remove_column :products, :discount_price
    remove_column :products, :retail_cents
    remove_column :products, :offer_cents

    add_column :products, :offer_cents, :integer, :default=>0
    add_column :products, :retail_cents, :integer, :default=>0    
    add_column :products, :currency, :string, :limit=>3, :default=>"USD"
    
  end

  def self.down
    remove_column :products, :currency

    add_column :products, :discount_price, :float
    add_column :products, :retail_currency, :string
    add_column :products, :offer_currency, :string
    
    remove_column :account_types, :currency
    remove_column :account_types, :flat_fee_cents
    remove_column :account_types, :commission_cents
    remove_column :account_types, :price_cents
    
    add_column :account_types, :flat_fee, :float, :default => 0.0
    add_column :account_types, :commission, :float, :default => 0.0
    add_column :account_types, :current_price, :float, :default => 0.0
    
    remove_column :line_items, :currency
    remove_column :line_items, :total_cents
    add_column :line_items, :total_price, :float, :default => 0.0
  end
end
