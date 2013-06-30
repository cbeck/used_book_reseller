class CreateAuthenticatedUsers < ActiveRecord::Migration
  def self.up
    #drop_table :sellers_users
    #drop_table :orders_users
    drop_table :users
    
    create_table "users", :force => true do |t|
      t.column "login",            :string, :limit => 40
      t.column "email",            :string, :limit => 100
      t.column "crypted_password", :string, :limit => 40
      t.column "salt",             :string, :limit => 40
      t.column "activation_code",  :string, :limit => 40 # only if you want
      t.column "activated_at",     :datetime             # user activation
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
      t.column "remember_token",   :string
      t.column "remember_token_expires_at", :datetime
    end
    
  end

  def self.down
  end
end
