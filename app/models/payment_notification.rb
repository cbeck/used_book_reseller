class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  
end
