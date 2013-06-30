class CreateMetroAreas < ActiveRecord::Migration
  def self.up
    create_table :metro_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :metro_areas
  end
end
