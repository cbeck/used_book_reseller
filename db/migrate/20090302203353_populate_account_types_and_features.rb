class PopulateAccountTypesAndFeatures < ActiveRecord::Migration
  def self.up
    account_types = AccountType.all
    account_types.each {|acct_type|
      acct_type.account_features.clear
    }
    AccountFeature.destroy_all
    AccountType.destroy_all
    
    free = AccountType.create (:name => "Free", :max_products => 3, :price_cents => 0, :flat_fee_cents => 0, :currency => "USD", :position => 4, :commission => 0, :enabled => true, :allow_signup => true)
    bookworm = AccountType.create (:name => "Bookworm", :price_cents => 600, :flat_fee_cents => 0, :currency => "USD", :position => 3, :commission => 0, :enabled => true, :allow_signup => true)
    apple_seed = AccountType.create (:name => "Apple Seed", :price_cents => 1200, :flat_fee_cents => 0, :currency => "USD", :position => 2, :commission => 2, :enabled => true, :allow_signup => false)
    apple_cart = AccountType.create (:name => "Apple Cart", :price_cents => 2400, :flat_fee_cents => 0, :currency => "USD", :position => 1, :commission => 2, :enabled => true, :allow_signup => false)
    
    allow_uploads = AccountFeature.create (:name => "allow_uploads", :position => 7, :description => "Sell downloadable products")
    bypass_inventory_management = AccountFeature.create (:name => "bypass_inventory_management", :position => 8, :description => "Sell your home-business products")
    browse = AccountFeature.create (:name => "browse", :position => 1, :description => "Unlimited shopping")
    yearly_sales_limit_lifted = AccountFeature.create (:name => "yearly_sales_limit_lifted", :position => 6, :description => "Annual listings")
    forums = AccountFeature.create (:name => "forums", :position => 4, :description => "Post in community forums")
    interact = AccountFeature.create (:name => "interact", :position => 3, :description => "Join social network (optional)")
    participate = AccountFeature.create (:name => "participate", :position => 2, :description => "Participate in free giveaways")
    wishlist = AccountFeature.create (:name => "wishlist", :position => 5, :description => "Wishlist notification")
    
    free_features = [browse, forums, interact, participate, wishlist]
    bookworm_features = [browse, forums, interact, participate, wishlist, yearly_sales_limit_lifted]
    apple_seed_features = [browse, forums, interact, participate, wishlist, yearly_sales_limit_lifted, allow_uploads]
    apple_cart_features = [browse, forums, interact, participate, wishlist, yearly_sales_limit_lifted, allow_uploads, bypass_inventory_management]
    
    free_features.each {|feat| free.account_features << feat}
    bookworm_features.each {|feat| bookworm.account_features << feat}
    apple_seed_features.each {|feat| apple_seed.account_features << feat}
    apple_cart_features.each {|feat| apple_cart.account_features << feat}
    
    free.save
    bookworm.save
    apple_seed.save
    apple_cart.save
    
    accounts = Account.all
    accounts.each {|acct| acct.account_type = bookworm; acct.save }
    
  end

  def self.down
    #oi!
  end
end
