class CreateItemFormats < ActiveRecord::Migration
  def self.up
    create_table :item_formats do |t|
      t.column :name,        :string
    end
  end

  def self.down
    drop_table :item_formats
  end
end
