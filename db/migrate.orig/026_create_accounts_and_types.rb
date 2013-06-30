class CreateAccountsAndTypes < ActiveRecord::Migration

  extend MigrationHelpers
  
  def self.up
    create_table "accounts" do |t|
      t.column :account_type_id,    :integer
      t.column :user_id,            :integer
      t.column :payment_type_id,    :integer
      t.column :payment_info,       :string
      t.column :created_at,         :datetime
      t.column :updated_at,         :datetime
    end
    
    create_table "account_types" do |t|
      t.column :name,               :string
    end
    
    create_table "account_features" do |t|
      t.column :name,               :string
    end
    
    create_table "account_types_account_features" do |t|
      t.column :account_type_id,    :integer
      t.column :account_feature_id, :integer
    end
    
    foreign_key(:account_types_account_features, :account_type_id, :account_types)    
    foreign_key(:account_types_account_features, :account_feature_id, :account_features)
    foreign_key(:accounts, :account_type_id, :account_types)    
    
  end

  def self.down
    remove_table :account_types_account_features
    remove_table :account_features
    remove_table :accounts
    remove_table :account_types    
  end
end
