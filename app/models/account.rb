class Account < ActiveRecord::Base
  belongs_to :account_type
  belongs_to :member
end
