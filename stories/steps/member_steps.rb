require File.dirname(__FILE__) + '/../helper'

RE_Member      = %r{(?:(?:the )? *(\w+) *)}
RE_Member_TYPE = %r{(?: *(\w+)? *)}
steps_for(:member) do

  #
  # Setting
  #
  
  Given "an anonymous member" do 
    log_out!
  end

  Given "$an $member_type member with $attributes" do |_, member_type, attributes|
    create_member! member_type, attributes.to_hash_from_story
  end
  
  Given "$an $member_type member named '$login'" do |_, member_type, login|
    create_member! member_type, named_member(login)
  end
  
  Given "$an $member_type member logged in as '$login'" do |_, member_type, login|
    create_member! member_type, named_member(login)
    log_in_member!
  end
  
  Given "$actor is logged in" do |_, login|
    log_in_member! @member_params || named_member(login)
  end
  
  Given "there is no $member_type member named '$login'" do |_, login|
    @member = Member.find_by_login(login)
    @member.destroy! if @member
    @member.should be_nil
  end
  
  #
  # Actions
  #
  When "$actor logs out" do 
    log_out
  end

  When "$actor registers an account as the preloaded '$login'" do |_, login|
    member = named_member(login)
    member['password_confirmation'] = member['password']
    create_member member
  end

  When "$actor registers an account with $attributes" do |_, attributes|
    create_member attributes.to_hash_from_story
  end
  
  When "$actor activates with activation code $attributes" do |_, activation_code|
    activation_code = '' if activation_code == 'that is blank'
    activate 
  end  

  When "$actor logs in with $attributes" do |_, attributes|
    log_in_member attributes.to_hash_from_story
  end
  
  #
  # Result
  #
  Then "$actor should be invited to sign in" do |_|
    response.should render_template('/sessions/new')
  end
  
  Then "$actor should not be logged in" do |_|
    controller.logged_in?.should_not be_true
  end
    
  Then "$login should be logged in" do |login|
    controller.logged_in?.should be_true
    controller.current_member.should === @member
    controller.current_member.login.should == login
  end
    
end

def named_member login
  member_params = {
    'admin'   => {'id' => 1, 'login' => 'addie', 'password' => '1234addie', 'email' => 'admin@example.com',       },
    'oona'    => {          'login' => 'oona',   'password' => '1234oona',  'email' => 'unactivated@example.com'},
    'reggie'  => {          'login' => 'reggie', 'password' => 'monkey',    'email' => 'registered@example.com' },
    }
  member_params[login.downcase]
end

#
# Member account actions.
#
# The ! methods are 'just get the job done'.  It's true, they do some testing of
# their own -- thus un-DRY'ing tests that do and should live in the member account
# stories -- but the repetition is ultimately important so that a faulty test setup
# fails early.  
#

def log_out 
  get '/sessions/destroy'
end

def log_out!
  log_out
  response.should redirect_to('/')
  follow_redirect!
end

def create_member(member_params={})
  @member_params       ||= member_params
  post "/members", :member => member_params
  @member = Member.find_by_login(member_params['login'])
end

def create_member!(member_type, member_params)
  member_params['password_confirmation'] ||= member_params['password'] ||= member_params['password']
  create_member member_params
  response.should redirect_to('/')
  follow_redirect!
 
  # fix the member's activation status
  activate_member! if member_type == 'activated'
end

 
def activate_member activation_code=nil
  activation_code = @member.activation_code if activation_code.nil?
  get "/activate/#{activation_code}"
end

def activate_member! *args
  activate_member *args
  response.should redirect_to('/login')
  follow_redirect!
  response.should have_flash("notice", /Signup complete!/)
end

def log_in_member member_params=nil
  @member_params ||= member_params
  member_params  ||= @member_params
  post "/session", member_params
  @member = Member.find_by_login(member_params['login'])
  controller.current_member
end

def log_in_member! *args
  log_in_member *args
  response.should redirect_to('/')
  follow_redirect!
  response.should have_flash("notice", /Logged in successfully/)
end
