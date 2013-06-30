class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.column :product_id, :integer, :null => false
      t.column :order_id, :integer, :null => false
      t.column :quantity, :integer, :null => false
      t.column :total_price, :float, :null => false, :precision => 8, :scale => 2
    end
    
    execute "alter table line_items
      add constraint fk_line_item_products
      foreign key (product_id) references products(id)"
      
    execute "alter table line_items
      add constraint fk_line_item_orders
      foreign key (order_id) references orders(id)"
  end

  def self.down
    drop_table :line_items
  end
end
