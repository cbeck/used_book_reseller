require "#{File.dirname(__FILE__)}/../test_helper"

class SellerTest < ActionController::IntegrationTest
  fixtures :users, :sellers, :roles, :roles_users, :sellers_users, :products, :product_images, :categories, :categories_products
  
  def test_add_seller_account
    quentin = enter_site(:quentin)
    quentin.tries_to_go_to_admin
    quentin.logs_in_successfully
    
    quentin.creates_seller_account
    quentin.chooses_seller_account
    quentin.creates_new_product
    quentin.uploads_product_image
    quentin.verifies_product_is_correct
  end
  
  private
  
  module SellerTestDSL
    include ERB::Util
    
    attr_writer :name
    
    def tries_to_go_to_admin
      get sellers_url
      assert_response :redirect
      assert_redirected_to new_session_url
    end
    
    def logs_in_successfully
      post sessions_url, :login => "aaron", :password => "test"
      assert_response :redirect
      assert_redirected_to sellers_url
    end
    
    def creates_seller_account
      post sellers_url, :seller => {:name => 'Bobo the Monkey Store', :email => 'cbeck@thirddayweb.com'}
      assert_response :redirect
      assert_redirected_to seller_path(assigns(:seller))
    end
    
    def chooses_seller_account
      put sessions_url, :id => 2
    end
    
    def creates_new_product
      post products_url, :product => {:title => "MyNewProduct" ,
        :description => "yyy" ,
        :price => 1  }  
      assert_redirected_to product_path(assigns(:product))       
    end
    
    def uploads_product_image
      # still done in unit test fashion until I figure out how to do with post
      product = Product.find_by_title("MyNewProduct")
      count = product.product_images.size
      product.add_product_image(product_images(:image_2))
      assert_equal count + 1, product.product_images.size
      assert product.product_images.include?(product_images(:image_2))
    end
    
    def verifies_product_is_correct
      my_new_product = Product.find_by_title("MyNewProduct")
      assert !my_new_product.nil?
    end   
    
   
  end
  
  def enter_site(name)
    open_session do |session|
      session.extend(SellerTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
  
end
