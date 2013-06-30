class RemoveUserTables < ActiveRecord::Migration
  def self.up
    drop_table :sellers_users
    drop_table :orders_users
    drop_table :users
    
  end

  def self.down
    create_table :users do |t|
      t.column :name, :string
      t.column :hashed_password, :string
      t.column :salt, :string
    end
    add_column :users, :email, :string, :limit => 80, :null => false
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string, :limit => 20
    add_column :users, :zip, :string, :limit => 10
    add_column :users, :country, :string, :limit => 50
    add_column :users, :phone, :string, :limit => 30
    
    create_table :sellers_users, :id => false do |t|
      t.column :seller_id, :integer, :null => false
      t.column :user_id, :integer, :null => false      
    end
    
    foreign_key(:sellers_users, :seller_id, :sellers)
    foreign_key(:sellers_users, :user_id, :users)
    
    create_table :orders_users, :id => false do |t|
      t.column :order_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    
    foreign_key(:orders_users, :order_id, :orders)
    foreign_key(:orders_users, :user_id, :users)
  end
end
