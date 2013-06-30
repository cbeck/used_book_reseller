class Status < ActiveRecord::Base
  has_many :products
  acts_as_enumerated
  
  def code_name
    name.gsub(/[\s]/, '').underscore
  end
end
