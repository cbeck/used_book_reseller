class AddMoneyToProduct < ActiveRecord::Migration
  def self.up
    remove_column :products, :price
    add_column :products, :offer_cents, :integer, :default=>0
    add_column :products, :offer_currency, :string, :limit=>3
    add_column :products, :retail_cents, :integer, :default=>0
    add_column :products, :retail_currency, :string, :limit=>3
  end

  def self.down
    remove_column :products, :retail_currency
    remove_column :products, :retail_cents
    remove_column :products, :offer_currency
    remove_column :products, :offer_cents
    add_column :products, :price, :float, :default => 0.0
  end
end
