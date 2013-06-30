class ExtendProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :condition, :string
    add_column :products, :created_at, :datetime
    add_column :products, :updated_at, :datetime
    add_column :products, :publish_at, :datetime
    add_column :products, :published, :boolean, :default => 1
    add_column :products, :discount_desc, :string 
    add_column :products, :discount_price, :float
    add_column :products, :quantity_avail, :integer, :default => 1, :null => false
    add_column :products, :isbn, :string
    add_column :products, :internal_id, :string
    add_column :products, :status_id, :integer, :limit => 2
  end

  def self.down
    remove_column :products, :condition
    remove_column :products, :created_at
    remove_column :products, :updated_at
    remove_column :products, :publish_at
    remove_column :products, :published
    remove_column :products, :discount_desc 
    remove_column :products, :discount_price
    remove_column :products, :quantity_avail
    remove_column :products, :isbn
    remove_column :products, :internal_id
    remove_column :products, :status_id
  end
end
