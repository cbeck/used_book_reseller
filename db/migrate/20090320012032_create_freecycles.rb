class CreateFreecycles < ActiveRecord::Migration
  def self.up
    create_table :freecycles do |t|
      t.string :name
      t.text :description
      t.integer :member_id
      t.string :metro_area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :freecycles
  end
end
