class AddAttributesToProduct < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.string :author
      t.string :small_image_url
      t.string :medium_image_url
      t.string :large_image_url
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :authorlist
      t.remove :small_image_url
      t.remove :medium_image_url
      t.remove :large_image_url
    end
  end
end
