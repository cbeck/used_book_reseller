class AddWeightToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.integer :weight
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :weight
    end
  end
end
