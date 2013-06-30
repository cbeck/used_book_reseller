class ItemFormat < ActiveRecord::Base
  has_many :products
  # acts_as_enumerated
  acts_as_list
  
end
