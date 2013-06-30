class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :name,                      :string,   :limit => 40
      t.column :email,                     :string,   :limit => 100
      t.column :crypted_password,          :string,   :limit => 40
      t.column :salt,                      :string,   :limit => 40
      t.column :activation_code,           :string,   :limit => 40
      t.column :activated_at,              :datetime
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
    end    
  end

  def self.down
    drop_table :people
  end
end
