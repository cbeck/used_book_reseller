class SetUpAdminUser < ActiveRecord::Migration
  def self.up
    #Be sure to change these settings for your initial admin user
    user = Member.new
		user.login = "admin"
		user.email = "admin@netphase.com"
		user.password = "n00dle!"
		user.password_confirmation = "n00dle!"
    user.save
		role = Role.new
		#Admin role name should be "admin" for convenience
		role.name = "admin"
		role.save
		admin_user = Member.find_by_login("admin")
		admin_role = Role.find_by_name("admin")
		admin_user.activated_at = Time.now.utc
		admin_user.state = 'active'
		admin_user.roles << admin_role
		admin_user.save
  end

  def self.down
    admin_user = Member.find_by_login("admin")
		admin_role = Role.find_by_name("admin")
		admin_user.roles = []
    admin_user.save
    admin_user.destroy
		admin_role.destroy
  end
end
