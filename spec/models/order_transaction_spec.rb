require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OrderTransaction do
  before(:each) do
    @valid_attributes = {
      :order_id => "1",
      :amount => "1",
      :success => false,
      :reference => "value for reference",
      :message => "value for message",
      :action => "value for action",
      :params => "value for params",
      :test => false
    }
  end

  before(:each) do
    @amount = 100
  end

  it "should create a new instance given valid attributes" do
    OrderTransaction.create!(@valid_attributes)
  end
  
  describe "Authorizing payment" do
    it "should handle a successful auth" do
      auth = OrderTransaction.authorize(@amount, credit_card(:number => '1'))
      auth.should be_success
      auth.action.should == 'authorization'
      auth.message.should == BogusGateway::SUCCESS_MESSAGE
      auth[:reference].should == BogusGateway::AUTHORIZATION
    end

    it "should handle a failed auth" do
      auth = OrderTransaction.authorize(@amount, credit_card(:number => '2'))
      auth.should_not be_success
      auth.action.should == 'authorization'
      auth.message.should == BogusGateway::FAILURE_MESSAGE
    end
  
    it "should handle an exception during auth" do
      auth = OrderTransaction.authorize(@amount, credit_card(:number => '3'))
      auth.should_not be_success
      auth.action.should == 'authorization'
      auth.message.should == BogusGateway::ERROR_MESSAGE
    end
  end
  
  describe  "Capturing payment" do
    it "should handle successful capture" do
      capt = OrderTransaction.capture(@amount, '123')
      capt.should be_success
      capt.action.should == 'capture'
      capt.message.should == BogusGateway::SUCCESS_MESSAGE
    end
    
    it "should handle failed capture" do
      capt = OrderTransaction.capture(@amount, '2')
      capt.should_not be_success
      capt.action.should == 'capture'
      capt.message.should == BogusGateway::FAILURE_MESSAGE
    end
    
    it "should handle exception during capture" do
      capt = OrderTransaction.capture(@amount, '1')
      capt.should_not be_success
      capt.action.should == 'capture'
      capt.message.should == BogusGateway::CAPTURE_ERROR_MESSAGE
    end
  end
end
