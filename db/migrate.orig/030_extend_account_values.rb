class ExtendAccountValues < ActiveRecord::Migration
  def self.up
    add_column :account_values, :value_modifier, :string
    add_column :account_values, :description, :string    
  end

  def self.down
    remove_column :account_values, :value_modifier
    remove_column :account_values, :description
  end
end
