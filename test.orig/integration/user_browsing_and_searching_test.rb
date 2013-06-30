require File.dirname(__FILE__) + '/../test_helper'

class UserBrowsingAndSearchingTest < ActionController::IntegrationTest
  fixtures :products, :users
  
  def test_browsing_and_searching
    quentin = enter_site(:quentin)
    first_book = quentin.browses_for_book
    quentin.adds_book_to_cart first_book
    second_book = quentin.searches_for_book
    quentin.adds_book_to_cart second_book
    quentin.attempts_to_check_out
    quentin.logs_in
    quentin.may_now_check_out
    
    quentin.verifies_cart_is_empty
    quentin.checks_order_status first_book
  end
  
  private
  
  module BrowseAndSearchTestDSL
    include ERB::Util
    include GenericTestHelper 
    
    attr_writer :name
    
    def browses_for_book
      get "/site/index"
      assert_response :success
      assert_template "index"
      products(:ruby_book)
    end
    
    def adds_book_to_cart(book)
      cart = session[:cart]
      xml_http_request cart_item_path(book)
      assert_response :success
      updated = session[:cart]
      assert_equal updated.total_items, cart.total_items + 1    
    end
    
    def searches_for_book
      get "/site/search?q=#{url_encode("Agile Web Development")}"
      prods =  assigns(:products)
      assert_response :success
      prods[0]
    end
    
    def attempts_to_check_out
      get new_order_path
      assert_response :redirect    
    end
    
    def logs_in
      post_via_redirect session_path, {:login => users(:quentin).login, :password => users(:quentin).password}
      #puts self.current_user.login
      assert_response :success    
    end
    
    def may_now_check_out
      #puts session.current_user.login
      post_via_redirect "/orders/create" ,
      :order => {
        :name => "Dave Thomas" ,
        :address_line_1 => "123 The Street" ,
        :email => "dave@pragprog.com" ,
        :pay_type => "check"
      }
      assert_response :success
      assert_template "index"
    end
    
    def verifies_cart_is_empty
      assert_equal 0, session[:cart].items.size
    end
    
    def checks_order_status(book)
      orders = Order.find(:all)
      assert_equal 3, orders.size
      order = orders[2]
      puts "database checked"
      
      # did we order it?
      assert_equal "Dave Thomas" , order.name
      assert_equal "123 The Street" , order.address_line_1
      assert_equal "dave@pragprog.com" , order.email
      assert_equal "check" , order.pay_type
      assert_equal 2, order.line_items.size
      
      # did it have our product?
      line_item = order.line_items.find_by_product_id(book)
      assert_equal book, line_item.product
      puts "test completed"
    end       
   
  end
  
  def enter_site(name)
    open_session do |session|
      session.extend(BrowseAndSearchTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
end
