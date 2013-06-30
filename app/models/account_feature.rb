class AccountFeature < ActiveRecord::Base
  has_and_belongs_to_many :account_types
  acts_as_list
end
