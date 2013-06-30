class ShippingTerm < ActiveRecord::Base
  has_many :sellers
end
