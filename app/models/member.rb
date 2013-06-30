require 'digest/sha1'

class Member < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  
  has_one :account, :dependent => :destroy
  has_one :seller
  has_one :profile
  has_one :avatar
  has_many :orders, :order => "id DESC"
  has_many :line_items, :through => :orders
  has_many :freecycles
  
  has_many :forum_posts
  has_and_belongs_to_many :roles
  has_many :followers
  has_many :followings, :through => :followers, :class_name => 'Member'
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  def passwd(p)
    self.password = p
    self.password_confirmation = p
    save(false) && "password reset"
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u = find_in_state :first, :active, :conditions => {:email => login} if u.blank?
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def feedback
    line_items.collect {|li| li.feedback}.compact
  end
  
  def needs_feedback
    line_items.select {|li| !li.has_feedback? }
  end
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  
  def is_admin?
    has_role? :admin
  end
  
  # these are items that have not been shipped to this buyer yet
  def pending_purchases
    line_items.select {|li| li.buyer_paid?} unless line_items.empty?
  end
  
  def incomplete_orders
    incompletes = []
    incompletes = orders.select {|o| o.incomplete?} unless orders.empty?
    incompletes
  end
  
  def unshipped_items
    unshippeds = []
    unshippeds = seller.unshipped_items unless seller.nil?
    unshippeds
  end
  
  
  
  # def replace_avatar(avatar)
  #     #need to purge old file from filesystem
  #     old_avatar = self.avatar
  #     if !old_avatar.nil? && old_avatar.has_saved_image?
  #       old_avatar.delete_image_file
  #       old_avatar.destroy
  #     end
  #     self.avatar = avatar
  #   end

  def forgot_password
    self.crypted_password = nil
    self.make_password_reset_code
    @forgotten_password = true
    save(false)
  end
  
  def recently_forgot_password?
    @forgotten_password
  end
  
  def reset_password    
    self.password_reset_code = nil
    self.password_reset_at = Time.now.utc
    @reset_password = true
    save(false)
  end
 
  def recently_reset_password?
    @reset_password
  end
  
  protected
    
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end

    def make_password_reset_code
      self.password_reset_code = 
        Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

end
