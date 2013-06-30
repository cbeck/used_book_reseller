class DatabasePurge < ActiveRecord::Migration
  def self.up
    
    execute "delete from categories_products" 
    execute "delete from line_items"    
    execute "delete from orders"    
    execute "delete from product_images"    
    execute "delete from products"    
    execute "delete from roles_users where role_id != 2"    
    execute "delete from roles where id != 2"    
    execute "delete from sellers_users"    
    execute "delete from sellers"    
    execute "delete from sessions"    
    execute "delete from accounts where user_id != 1"  
    execute "delete from users where id != 1"  
    execute "delete from payment_types where id != 1"
    
  end

  def self.down
  end
end
