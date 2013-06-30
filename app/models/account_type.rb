class AccountType < ActiveRecord::Base
  acts_as_list
  
  has_and_belongs_to_many :account_features
  has_many :accounts
  has_many :members, :through => :accounts
  composed_of :price, :class_name => "Money", 
    :mapping => [%w(price_cents cents), %w(currency currency)]
  composed_of :flat_fee, :class_name => "Money", 
    :mapping => [%w(flat_fee_cents cents), %w(currency currency)]
  
  def is_free?
    has_no_charge?(price_cents) && has_no_charge?(flat_fee_cents) && has_no_charge?(commission)
  end
  
  def self.free_account
    AccountType.find_by_name("Free Forever")
  end
  
  private
  
  def has_no_charge?(amount)
    return true if amount.blank?
    (amount.is_a? Money) ? amount == Money.new(0) : amount == 0
  end
  
  
end
