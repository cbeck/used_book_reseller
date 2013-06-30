class AccountTypesFeaturesOrderAndValues < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    add_column :account_types, :order, :integer
    add_column :account_features, :order, :integer
    
    create_table "account_values" do |t|
      t.column :account_type_id,    :integer
      t.column :account_feature_id, :integer
      t.column :value,              :string
    end
    
    drop_table :account_types_account_features
    
    foreign_key(:account_values, :account_type_id, :account_types)    
    foreign_key(:account_values, :account_feature_id, :account_features)    
    
  end

  def self.down
    # keeping the removal of :account_types_account_features because it is wrong syntactically
    drop_table :account_values
    remove_column :account_types, :order
    remove_column :account_features, :order
  end
end
