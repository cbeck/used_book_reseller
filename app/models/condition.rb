class Condition < ActiveRecord::Base
  has_many :products
  acts_as_enumerated
end
