class Forum < ActiveRecord::Base
  has_many :forum_posts
  belongs_to :forum_groups
end
