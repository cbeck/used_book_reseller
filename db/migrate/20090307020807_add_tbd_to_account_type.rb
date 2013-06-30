class AddTbdToAccountType < ActiveRecord::Migration
  def self.up
    change_table :account_types do |t|
      t.boolean :pricing_tbd
    end
    
    AccountType.reset_column_information

    apple_seed = AccountType.find_by_name("Apple Seed")
    apple_cart = AccountType.find_by_name("Apple Cart")
    
    apple_seed.update_attribute :pricing_tbd, true
    apple_cart.update_attribute :pricing_tbd, true
  end

  def self.down
    change_table :account_types do |t|
      t.remove :pricing_tbd
    end
  end
end
