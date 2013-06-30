require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/carriers/show.html.erb" do
  include CarriersHelper
  
  before(:each) do
    assigns[:carrier] = @carrier = stub_model(Carrier,
      :name => "value for name",
      :url => "value for url",
      :tracking_url => "value for tracking_url"
    )
  end

  it "should render attributes in <p>" do
    render "/carriers/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ url/)
    response.should have_text(/value\ for\ tracking_url/)
  end
end

