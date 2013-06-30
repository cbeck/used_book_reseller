class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.integer :member_id
    end
  end

  def self.down
    drop_table :avatars
  end
end
