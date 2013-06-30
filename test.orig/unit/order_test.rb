require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < Test::Unit::TestCase
  fixtures :orders, :line_items, :products

  def test_invalid_with_empty_attributes
    order = Order.new
    assert !order.valid?
    assert order.errors.invalid?(:name)
    assert order.errors.invalid?(:address_line_1)
    assert order.errors.invalid?(:email)
    assert order.errors.invalid?(:pay_type)
  end
  
  def test_pay_type_in_allowed_pay_types
    order = Order.new(:name => "Mojo Jojo" ,
      :address_line_1 => "123 Mojo St." ,
      :email => "mojo@jojo.com",
      :pay_type => "pinto beans" )
    assert !order.valid?
    order.pay_type = "cc"
    assert order.valid?
  end
  
  def test_add_line_items_from_cart_to_order
    cart = Cart.new
    cart.add_product products(:ruby_book)
    order = Order.new(:name => "Add Jojo" ,
      :address_line_1 => "123 Add St." ,
      :email => "add@jojo.com",
      :pay_type => "cc" )
    order.add_line_items_from_cart cart
    assert !order.line_items.empty?
    count = LineItem.count
    order.save
    assert_equal count + 1, LineItem.count
  end
end
