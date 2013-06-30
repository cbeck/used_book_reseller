require "#{File.dirname(__FILE__)}/../test_helper"

class UserAddingFeedbackOnPurchaseTest < ActionController::IntegrationTest
  fixtures :products, :users, :orders, :line_items, :feedback

  def test_buyer_adding_feedback_on_purchase
    quentin = enter_site(:quentin)
    quentin.logs_in("quentin", "test")
    order = quentin.selects_order
    print "my order is "
    puts order
    line_item = quentin.selects_line_item
    print "my line item is "
    puts line_item
    quentin.adds_feedback line_item
    
    # seller enters site
    aaron = enter_site(:aaron)
    aaron.logs_in("aaron", "test")
    aaron.notes_new_feedback
    all_feedback = aaron.views_all_feedback
    #aaron.views_feedback all_feedback[0]
  end
  
  private
  
  module UserAddsFeedbackTestDSL
    include ERB::Util
    include GenericTestHelper
    
    attr_writer :name
    
    #add methods here
    def logs_in(user_name, password)
      post sessions_url, :login => user_name, :password => password
      assert_response :redirect
      assert_redirected_to "/site/index"
      puts "logged in"
    end
    
    def selects_order
      get order_url(:id => 2)
      assert_response :success
      puts "order selected"
      order = assigns(:order)
    end
    
    def selects_line_item
      get line_item_url(:id => 3) 
      assert_response :success
      puts "line item selected"
      line_item =  assigns(:line_item)      
    end
    
    def adds_feedback(line_item)
      post feedback_url(:line_item_id => line_item, :id => nil), :feedback => {:feedback => "great", :comment => "i'd do business again"}
      assert_response :redirect
      li = assigns(:line_item)
      assert li.id == line_item.id
      puts "feedback added"
    end
    
    def notes_new_feedback
      assert true
      puts "new feedback noted"
    end
    
    def views_all_feedback
      assert true
      puts "viewed all feedback"
    end
    
    def views_feedback
      assert true
      puts "viewing feedback item"
    end
    
  end
  
  def enter_site(name)
    print name
    puts " enters site"
    open_session do |session|
      session.extend(UserAddsFeedbackTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
end
