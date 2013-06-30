class CreateForumPosts < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :forum_posts do |t|
      t.column :user_id, :integer, :null => false
      t.column :subject, :string, :limit => 255, :null => false
      t.column :body, :text
      t.column :root_id, :integer
      t.column :parent_id, :integer
      t.column :lft, :integer
      t.column :rgt, :integer
      t.column :depth, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :forum_id, :integer, :null => false, :default => 0 #general category
    end
    
    
  end

  def self.down
    drop_table :forum_posts
  end
end
