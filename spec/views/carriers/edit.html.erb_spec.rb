require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/carriers/edit.html.erb" do
  include CarriersHelper
  
  before(:each) do
    assigns[:carrier] = @carrier = stub_model(Carrier,
      :new_record? => false,
      :name => "value for name",
      :url => "value for url",
      :tracking_url => "value for tracking_url"
    )
  end

  it "should render edit form" do
    render "/carriers/edit.html.erb"
    
    response.should have_tag("form[action=#{carrier_path(@carrier)}][method=post]") do
      with_tag('input#carrier_name[name=?]', "carrier[name]")
      with_tag('input#carrier_url[name=?]', "carrier[url]")
      with_tag('input#carrier_tracking_url[name=?]', "carrier[tracking_url]")
    end
  end
end


