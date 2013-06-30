class AddPositionToAccountTypesAndFeatures < ActiveRecord::Migration
  def self.up
    change_table :account_types do |t|
      t.integer :position
    end
    change_table :account_features do |t|
      t.integer :position
    end
  end

  def self.down
    change_table :account_types do |t|
      t.remove :position
    end
    change_table :account_features do |t|
      t.remove :position
    end
  end
end
