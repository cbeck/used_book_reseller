require "#{File.dirname(__FILE__)}/../test_helper"

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products, :users
  
  def test_registered_user_buying_a_product
    # setting the scene
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby_book)
    puts "set-up done"
    
    # go to the home page
    get "/site/index"
    assert_response :success
    assert_template "index"
    puts "home done"
    
    # choose a product and add to the cart
    xml_http_request cart_item_path(ruby_book) 
    assert_response :success
    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product
    puts "add to cart done"
    
    # checkout attempt - need to login
    get new_order_path
    assert_response :redirect
    post_via_redirect session_path, {:login => users(:quentin).login, :password => users(:quentin).password}
    assert_response :success
    puts "login done"
    
    # fill out the order form, follow redirects
    post_via_redirect "/orders/create" ,
      :order => {
        :name => "Dave Thomas" ,
        :address_line_1 => "123 The Street" ,
        :email => "dave@pragprog.com" ,
        :pay_type => "check"
      }
    assert_response :success
    assert_template "index"
    assert_equal 0, session[:cart].items.size
    puts "order saved"
    
    # check the database for the order
    orders = Order.find(:all)
    assert_equal 1, orders.size
    order = orders[0]
    puts "database checked"
    
    # did we order it?
    assert_equal "Dave Thomas" , order.name
    assert_equal "123 The Street" , order.address_line_1
    assert_equal "dave@pragprog.com" , order.email
    assert_equal "check" , order.pay_type
    assert_equal 1, order.line_items.size
    
    # did it have our product?
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    puts "test completed"
  end
  
end
