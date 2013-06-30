class AddDescriptionToSeller < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.text :description
    end
  end

  def self.down
    change_table :sellers do |t|
      t.remove :description
    end
  end
end
