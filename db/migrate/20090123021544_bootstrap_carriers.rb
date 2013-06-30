class BootstrapCarriers < ActiveRecord::Migration
  def self.up
    Carrier.create :name=>"US Postal Service", :url => "http://www.usps.com", :tracking_url => "http://www.usps.com/shipping/trackandconfirm.htm"
    Carrier.create :name=>"UPS", :url => "http://www.ups.com/content/us/en/index.jsx", :tracking_url => "http://wwwapps.ups.com/WebTracking/track"
    Carrier.create :name=>"FedEx", :url => "http://fedex.com/us/", :tracking_url => "http://www.fedex.com/Tracking?cntry_code=us"
  end

  def self.down
    #nichts
  end
end
