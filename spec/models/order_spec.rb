require File.dirname(__FILE__) + '/../spec_helper'

describe Order do
  fixtures :orders, :order_transactions

  describe 'Payment authorization' do
    it "should handle success" do
      order = orders(:pending)
      credit_card = credit_card(:number => '1')
      lambda {
        authorization = order.authorize_payment(credit_card)
        authorization.reference.should == order.authorization_reference
        authorization.should be_success
        order.should be_authorized
      }.should change(order.transactions, :count)
    end
  
    it  "should handle failure" do
      order = orders(:pending)
      credit_card = credit_card(:number => '2')
      lambda {
        authorization = order.authorize_payment(credit_card)
        order.authorization_reference.should be_nil
        authorization.should_not be_success
        order.should be_payment_declined
      }.should change(order.transactions, :count)
    end

    it "should handle exception during" do
      order = orders(:pending)
      credit_card = credit_card(:number => '3')
      lambda {
        authorization = order.authorize_payment(credit_card)
        order.authorization_reference.should be_nil
        authorization.should_not be_success
        order.should be_payment_declined
      }.should change(order.transactions, :count)
    end
  end
  
  describe 'Payment capture' do
    it "should handle success" do
      order = orders(:authorized)
      lambda {
        capture = order.capture_payment
        assert order.paid?
        assert capture.success?
      }.should change(order.transactions, :count)
    end

    it "should handle failure" do
      order = orders(:uncapturable)
      lambda {
        capture = order.capture_payment
        order.should be_authorized
        capture.should_not be_success
      }.should change(order.transactions, :count)
    end
    
    it "should handle exception during" do
      order = orders(:uncapturable_error)
      lambda {
        capture = order.capture_payment
        order.should be_authorized
        capture.should_not be_success
      }.should change(order.transactions, :count)
    end
    
  end
end