class AddNameOnCheckToSellers < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.string :name_on_check
    end
  end

  def self.down
    change_table :sellers do |t|
      t.remove :name_on_check
    end
  end
end
