class CreateForumGroups < ActiveRecord::Migration
  def self.up
    create_table :forum_groups do |t|
    end
  end

  def self.down
    drop_table :forum_groups
  end
end
