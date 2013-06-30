require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Carrier do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      :tracking_url => "value for tracking_url"
    }
  end

  it "should create a new instance given valid attributes" do
    Carrier.create!(@valid_attributes)
  end
end
