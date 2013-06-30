class AddNoTrackingToCarriers < ActiveRecord::Migration
  def self.up
    Carrier.create(:name => "Other (Provide Name and Number in Box)")
    Carrier.create(:name => "No Tracking Information Available")
  end

  def self.down
  end
end
