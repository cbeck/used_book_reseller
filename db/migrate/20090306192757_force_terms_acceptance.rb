class ForceTermsAcceptance < ActiveRecord::Migration
  def self.up
    # for exisiting sellers before launch only!
    Seller.update_all("accepted_terms = 1")
  end

  def self.down
  end
end
