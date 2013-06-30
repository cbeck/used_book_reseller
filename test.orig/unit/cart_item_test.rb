require File.dirname(__FILE__) + '/../test_helper'

class CartItemTest < Test::Unit::TestCase
  fixtures :products
  
  def setup
    @rails = products(:rails_book)
    @cart_item = CartItem.new(@rails)    
  end
  
  def test_increment_quantity
    q = @cart_item.quantity
    @cart_item.increment_quantity
    assert_equal q + 1, @cart_item.quantity
  end
  
  def test_decrement_quantity
    q = @cart_item.quantity
    @cart_item.decrement_quantity
    assert_equal q - 1, @cart_item.quantity
  end
  
  def test_title
    assert_equal @cart_item.product.title, @rails.title
  end
  
  def test_price
    assert_equal @cart_item.product.price * @cart_item.quantity, @rails.price * @cart_item.quantity
  end  
  
end
