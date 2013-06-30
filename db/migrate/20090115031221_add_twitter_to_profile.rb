class AddTwitterToProfile < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.string :twitter_url
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :twitter_url
    end
  end
end
