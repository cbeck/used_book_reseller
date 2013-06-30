class AddCurrentPriceToAccountType < ActiveRecord::Migration
  def self.up
    add_column :account_types, :current_price, :float, :precision=>8, :scale=>2, :default=>0
  end

  def self.down
    remove_column :account_types, :current_price
  end
end
