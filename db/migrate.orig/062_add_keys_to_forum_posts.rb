class AddKeysToForumPosts < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    foreign_key(:forum_posts, :forum_id, :forums) 
    foreign_key(:forum_posts, :user_id, :users)      
  end

  def self.down
  end
end
