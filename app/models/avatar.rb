class Avatar < ActiveRecord::Base
  acts_as_fleximage :image_directory => 'public/images/avatars'
  
  belongs_to :member
  
end
