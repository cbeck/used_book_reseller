require File.dirname(__FILE__) + '/../test_helper'

class LineItemTest < Test::Unit::TestCase
  fixtures :line_items, :products
  
  def setup
    @rails = products(:rails_book)
    @cart_item = CartItem.new(@rails)    
  end
  
  def test_create_line_item_from_cart_item
    line_item = LineItem.from_cart_item(@cart_item)
    assert_equal line_item.quantity, @cart_item.quantity
    assert_equal line_item.total_price, @cart_item.price
    assert_equal line_item.product, @cart_item.product  
  end
end
