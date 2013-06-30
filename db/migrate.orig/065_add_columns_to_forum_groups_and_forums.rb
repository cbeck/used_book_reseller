class AddColumnsToForumGroupsAndForums < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    add_column :forums, :enabled, :boolean
    add_column :forums, :forum_group_id, :integer
    add_column :forum_groups, :name, :string
    add_column :forum_groups, :description, :text
    add_column :forum_groups, :created_at, :timestamp
    add_column :forum_groups, :enabled, :boolean
    
    foreign_key(:forums, :forum_group_id, :forum_groups)
  end

  def self.down
    remove_column :forums, :enabled
    remove_column :forums, :forum_group_id
    remove_column :forum_groups, :name
    remove_column :forum_groups, :description
    remove_column :forum_groups, :created_at
    remove_column :forum_groups, :enabled
  end
end
