class DestroyMembers < ActiveRecord::Migration
  def self.up
    drop_table "members"    
  end

  def self.down
  end
end
