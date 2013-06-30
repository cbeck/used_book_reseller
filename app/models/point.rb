class Point < ActiveRecord::Base
  belongs_to :rating
  belongs_to :member
end
