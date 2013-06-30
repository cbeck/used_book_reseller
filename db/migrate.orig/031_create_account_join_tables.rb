class CreateAccountJoinTables < ActiveRecord::Migration
  
  extend MigrationHelpers
  
  def self.up
    create_table "account_features_account_types", :id => false do |t|
      t.column :account_feature_id,    :integer
      t.column :account_type_id,       :integer
    end
    
    foreign_key(:account_features_account_types, :account_feature_id, :account_features)    
    foreign_key(:account_features_account_types, :account_type_id, :account_types)
    
  end

  def self.down
    drop_table :account_features_account_types
  end
end
