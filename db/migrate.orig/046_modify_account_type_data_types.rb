class ModifyAccountTypeDataTypes < ActiveRecord::Migration
  def self.up
    remove_column :account_types, :flat_fee
    remove_column :account_types, :commission
    add_column :account_types, :commission, :float, :precision=>8, :scale=>2, :default=>0
    add_column :account_types, :flat_fee, :float, :precision=>8, :scale=>2, :default=>0
  end

  def self.down
  end
end
