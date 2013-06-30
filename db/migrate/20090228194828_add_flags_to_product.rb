class AddFlagsToProduct < ActiveRecord::Migration
  def self.up
    rename_column :products, :condition, :condition_comments    
    change_table :products do |t|
      t.integer :condition_id
      t.boolean :nonsmoking_home
      t.boolean :no_pets_in_home
      t.boolean :use_amazon_image      
    end
  end

  def self.down
    rename_column :products, :condition_comments, :condition
    change_table :products do |t|
      t.remove :condition_id
      t.remove :nonsmoking_home
      t.remove :no_pets_in_home
      t.remove :use_amazon_image
    end
  end
end
