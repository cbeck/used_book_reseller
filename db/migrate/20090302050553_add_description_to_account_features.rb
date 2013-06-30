class AddDescriptionToAccountFeatures < ActiveRecord::Migration
  def self.up
    add_column :account_features, :description, :string
  end

  def self.down
    remove_column :account_features, :description
  end
end
