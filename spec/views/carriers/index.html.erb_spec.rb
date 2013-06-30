require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/carriers/index.html.erb" do
  include CarriersHelper
  
  before(:each) do
    assigns[:carriers] = [
      stub_model(Carrier,
        :name => "value for name",
        :url => "value for url",
        :tracking_url => "value for tracking_url"
      ),
      stub_model(Carrier,
        :name => "value for name",
        :url => "value for url",
        :tracking_url => "value for tracking_url"
      )
    ]
  end

  it "should render list of carriers" do
    render "/carriers/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for url", 2)
    response.should have_tag("tr>td", "value for tracking_url", 2)
  end
end

