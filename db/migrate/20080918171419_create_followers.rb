class CreateFollowers < ActiveRecord::Migration
  def self.up
    create_table :followers do |t|
      t.integer :member_id
      t.integer :following_id

      t.timestamps
    end
  end

  def self.down
    drop_table :followers
  end
end
