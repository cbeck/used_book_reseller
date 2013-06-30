require File.dirname(__FILE__) + '/../test_helper'

class ProductTest < Test::Unit::TestCase
  fixtures :products, :product_images, :publishers

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
    product = Product.new
    assert !product.valid?
    assert product.errors.invalid?(:title)
    assert product.errors.invalid?(:description)
    assert product.errors.invalid?(:price)
  end
  
  def test_length_of_title
    product = Product.new(:title => "xxx" ,
      :description => "yyy" ,
      :price => 1 )
    assert !product.valid?
    product.title = "thisneedstobe10characters"
    assert product.valid?
  end
  
  def test_positive_price
    product = products(:ruby_book)
    product.price = -1
    assert !product.valid?
    assert_equal "should be at least $.01" , product.errors.on(:price)
    product.price = 0
    assert !product.valid?
    assert_equal "should be at least $.01" , product.errors.on(:price)
    product.price = 1
    assert product.valid?
  end  
 
  def test_unique_title
    product = Product.new(:title => products(:ruby_book).title,
    :description => "yyy" ,
    :price => 1)
    assert !product.save
    assert_equal ActiveRecord::Errors.default_error_messages[:taken],
      product.errors.on(:title)
  end
  
  def test_find_products_for_sale
    check = Product.available
    assert_equal Product.count, check.size
  end
  
  def test_add_product_image
    product = products(:ruby_book)
    count = product.product_images.size
    product.add_product_image(product_images(:image_2))
    assert_equal count + 1, product.product_images.size
    assert product.product_images.include?(product_images(:image_2))
  end
  
  # def test_image_url
 #   ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
  #    http://a.b.c/x/y/z/fred.gif }
  #  bad = %w{ fred.doc fred.gif/more fred.gif.more }
  #  ok.each do |name|
  #    product = Product.new(:title => "thisneedstobe10characters" ,
  #      :description => "yyy" ,
  #      :price => 1,
  #      :image_url => name)
  #    assert product.valid?, product.errors.full_messages
  #  end
  #  bad.each do |name|
  #    product = Product.new(:title => "xxx" , :description => "yyy" , :price => 1,
  #      :image_url => name)
  #    assert !product.valid?, "saving #{name}"
  #  end
 # end
 
  def test_ferret
    Product.rebuild_index
    
    assert Product.find_by_contents("")
    
    assert_difference Product, :count do
      product = Product.new(:title => "Frogs Are Fun",
          :description => "I like frogs flambe." ,
          :price => 100)
      product.publisher = Publisher.find(1)
      assert product.valid?
      product.save
      
      prod = Product.find_by_title("Frogs Are Fun")
      publisher = prod.publisher_name
      
      assert_equal 1, Product.find_by_contents("Frogs").size
      assert_equal 1, Product.find_by_contents("flambe").size
      assert_equal 1, Product.find_by_contents("Winter Promise").size
    end
  end
   
end
