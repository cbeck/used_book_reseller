require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories, :products, :categories_products

  def test_available_products
    category = categories(:math)
    products = Product.available.for_category(category.id)
    assert_equal 2, products.size
  end
  
  def test_available_products?
    category = categories(:science)
    assert !Product.available.for_category(category.id).empty?
    category = categories(:grammar)
    assert Product.available.for_category(category.id).empty?

end
