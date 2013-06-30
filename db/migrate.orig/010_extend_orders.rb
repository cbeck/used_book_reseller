class ExtendOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :pay_info, :string
    rename_column :orders, :address, :address_line_1
    add_column :orders, :address_line_2, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string, :limit => 20
    add_column :orders, :zip, :string, :limit => 10
    add_column :orders, :country, :string, :limit => 50
    add_column :orders, :ship_to, :string
    add_column :orders, :ship_address_line_1, :string
    add_column :orders, :ship_address_line_2, :string
    add_column :orders, :ship_city, :string
    add_column :orders, :ship_state, :string, :limit => 20
    add_column :orders, :ship_zip, :string, :limit => 10
    add_column :orders, :ship_country, :string, :limit => 50
    add_column :orders, :created_at, :datetime    
  end

  def self.down
    remove_column :orders, :pay_info
    rename_column :orders, :address_line_1
    remove_column :orders, :address_line_2
    remove_column :orders, :city
    remove_column :orders, :state
    remove_column :orders, :zip
    remove_column :orders, :country
    remove_column :orders, :ship_to
    remove_column :orders, :ship_address_line_1
    remove_column :orders, :ship_address_line_2
    remove_column :orders, :ship_city
    remove_column :orders, :ship_state
    remove_column :orders, :ship_zip
    remove_column :orders, :ship_country
    remove_column :orders, :created_at
  end
end
