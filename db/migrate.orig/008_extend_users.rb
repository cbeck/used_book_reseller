class ExtendUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string, :limit => 80, :null => false
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string, :limit => 20
    add_column :users, :zip, :string, :limit => 10
    add_column :users, :country, :string, :limit => 50
    add_column :users, :phone, :string, :limit => 30
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :address_line_1
    remove_column :users, :address_line_2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip
    remove_column :users, :country
    remove_column :users, :phone
  end
end
