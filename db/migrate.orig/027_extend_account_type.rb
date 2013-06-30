class ExtendAccountType < ActiveRecord::Migration
  def self.up
    add_column :account_types, :description, :string
  end

  def self.down
    remove_column :account_types, :description
  end
end
