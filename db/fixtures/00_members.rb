# Populate user-related tables with default data

AccountType.destroy_all
AccountType.create :name => 'Free', 
  :max_monthly_sales => 100, :max_products => 3, :allow_paypal => true

# Role.delete_all
# Role.create

# don't need - admin user created in migration due to need to get around state machine
# User.create :login => 'demo_admin', :email => 'demo_admin@nepthase.com',
#   :password => 'test2', :password_confirmation => 'test2'

Seller.destroy_all
Member.destroy_all "login in ('buyer', 'buyer2', 'seller')"

u = Member.new :login => 'buyer', :email => 'demo_buyer@netphase.com',
  :password => 'f00bar', :password_confirmation => 'f00bar'
u.register!
u.activate!

u = Member.new :login => 'buyer2', :email => 'demo_buyer2@netphase.com',
  :password => 'f00bar', :password_confirmation => 'f00bar'
u.register!
u.activate!

u = Member.new :login => 'seller', :email => 'demo_seller@netphase.com',
  :password => 'f00bar', :password_confirmation => 'f00bar'
u.register!
u.activate!

@@seller = u.create_seller :name => 'Joe Seller', :email => u.email, :phone => '7045551212',
  :address_line_1 => '123 Pine St.', :city => 'Charlotte', :state => 'NC', :zip => '28277', :accepted_terms => true, :preferred_payment_method => 'mail'

