class FixAccountTypesAndFeatures < ActiveRecord::Migration
  def self.up
    change_table :account_types do |t|
      t.remove :order
      t.remove :max_monthly_sales
      t.remove :allow_paypal
      t.remove :allow_merchant_account
      t.remove :commission_cents
      t.float :commission 
    end
    
    change_table :account_features do |t|
      t.remove :order
    end
  end

  def self.down
    change_table :account_types do |t|
      t.integer :order
      t.integer :max_monthly_sales
      t.boolean :allow_paypal
      t.boolean :allow_merchant_account
      t.integer :commission_cents
      t.remove :commission 
    end
    
    change_table :account_features do |t|
      t.integer :order
    end
  end
end
