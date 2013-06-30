class Feedback < ActiveRecord::Base
  belongs_to :line_item
  
  validates_presence_of :line_item
  
  def member
    line_item.order.member
  end
  
  def seller
    line_item.seller
  end
  
end
