require File.dirname(__FILE__) + '/../spec_helper'

describe Order do
  fixtures :orders, :order_transactions

  before(:all) do
    OrderTransaction.gateway = BraintreeGateway.new(
      :login => 'demo',
      :password => 'password'
    )
  end

  before(:each) do
    @order = orders(:pending)
    # @order = Order.create(:status => :pending)
    @credit_card = credit_card(:number => '4111111111111111')

    @options = { 
      :description => 'A store purchase',
      :billing_address => address
    }
  end

  describe 'Payment authorization' do

    it "should successfully authorize order" do
      assert_difference '@order.transactions.count' do
        authorization = @order.authorize_payment(@credit_card, @options)
        authorization.reference.should == @order.authorization_reference
        authorization.should be_success
        @order.should be_authorized
      end
    end

    it "should fail authorization with invalid credit card number" do
      @credit_card.number = 'invalid'
      assert_difference '@order.transactions.count' do
        authorization = @order.authorize_payment(@credit_card, @options)
        @order.authorization_reference.should be_nil
        authorization.should_not be_success
        @order.should be_payment_declined
      end
    end

    it "should successfully authorize and capture" do
      assert_difference '@order.transactions.count', 2 do
        authorization = @order.authorize_payment(@credit_card, @options)
        authorization.should be_success
        @order.should be_authorized
        capture = @order.capture_payment
        capture.should be_success
        @order.should be_paid
      end
    end

    it "should handle successful authorization and unsuccessful capture" do
      assert_difference '@order.transactions.count', 2 do
        authorization = @order.authorize_payment(@credit_card, @options)
        authorization.should be_success
        @order.should be_authorized
        authorization_transaction = @order.transactions.first
        authorization_transaction.update_attribute(:reference, '')
        capture = @order.capture_payment
        capture.should_not be_success
        @order.should be_authorized
      end
    end
    
  end
end