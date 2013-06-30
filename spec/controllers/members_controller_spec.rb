require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.

describe MembersController do
  fixtures :members, :statuses
  
  before :all do
    Status[:Available]    # force enumration to initialize
  end

  it 'allows signup' do
    lambda do
      create_member
      response.should be_redirect
    end.should change(Member, :count).by(1)
  end

  
  it 'signs up user in pending state' do
    create_member
    assigns(:member).reload
    assigns(:member).should be_pending
  end

  it 'signs up user with activation code' do
    create_member
    assigns(:member).reload
    assigns(:member).activation_code.should_not be_nil
  end
  it 'requires login on signup' do
    lambda do
      create_member(:login => nil)
      assigns[:member].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(Member, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_member(:password => nil)
      assigns[:member].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(Member, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_member(:password_confirmation => nil)
      assigns[:member].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(Member, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_member(:email => nil)
      assigns[:member].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(Member, :count)
  end
  
  
  it 'activates user' do
    Member.authenticate('aaron', 'monkey').should be_nil
    get :activate, :activation_code => members(:aaron).activation_code
    response.should redirect_to('/login')
    flash[:notice].should_not be_nil
    flash[:error ].should     be_nil
    Member.authenticate('aaron', 'monkey').should == members(:aaron)
  end
  
  it 'does not activate user without key' do
    get :activate
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate user with bogus key' do
    get :activate, :activation_code => 'i_haxxor_joo'
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  def create_member(options = {})
    use_https
    post :create, :member => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe MembersController do
  describe "route generation" do
    it "should route members's 'index' action correctly" do
      route_for(:controller => 'members', :action => 'index').should == "/members"
    end
    
    it "should route members's 'new' action correctly" do
      route_for(:controller => 'members', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'members', :action => 'create'} correctly" do
      route_for(:controller => 'members', :action => 'create').should == "/register"
    end
    
    it "should route members's 'show' action correctly" do
      route_for(:controller => 'members', :action => 'show', :id => '1').should == "/members/1"
    end
    
    it "should route members's 'edit' action correctly" do
      route_for(:controller => 'members', :action => 'edit', :id => '1').should == "/members/1/edit"
    end
    
    it "should route members's 'update' action correctly" do
      route_for(:controller => 'members', :action => 'update', :id => '1').should == "/members/1"
    end
    
    it "should route members's 'destroy' action correctly" do
      route_for(:controller => 'members', :action => 'destroy', :id => '1').should == "/members/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for members's index action from GET /members" do
      params_from(:get, '/members').should == {:controller => 'members', :action => 'index'}
      params_from(:get, '/members.xml').should == {:controller => 'members', :action => 'index', :format => 'xml'}
      params_from(:get, '/members.json').should == {:controller => 'members', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for members's new action from GET /members" do
      params_from(:get, '/members/new').should == {:controller => 'members', :action => 'new'}
      params_from(:get, '/members/new.xml').should == {:controller => 'members', :action => 'new', :format => 'xml'}
      params_from(:get, '/members/new.json').should == {:controller => 'members', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for members's create action from POST /members" do
      params_from(:post, '/members').should == {:controller => 'members', :action => 'create'}
      params_from(:post, '/members.xml').should == {:controller => 'members', :action => 'create', :format => 'xml'}
      params_from(:post, '/members.json').should == {:controller => 'members', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for members's show action from GET /members/1" do
      params_from(:get , '/members/1').should == {:controller => 'members', :action => 'show', :id => '1'}
      params_from(:get , '/members/1.xml').should == {:controller => 'members', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/members/1.json').should == {:controller => 'members', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for members's edit action from GET /members/1/edit" do
      params_from(:get , '/members/1/edit').should == {:controller => 'members', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'members', :action => update', :id => '1'} from PUT /members/1" do
      params_from(:put , '/members/1').should == {:controller => 'members', :action => 'update', :id => '1'}
      params_from(:put , '/members/1.xml').should == {:controller => 'members', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/members/1.json').should == {:controller => 'members', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for members's destroy action from DELETE /members/1" do
      params_from(:delete, '/members/1').should == {:controller => 'members', :action => 'destroy', :id => '1'}
      params_from(:delete, '/members/1.xml').should == {:controller => 'members', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/members/1.json').should == {:controller => 'members', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route members_path() to /members" do
      members_path().should == "/members"
      formatted_members_path(:format => 'xml').should == "/members.xml"
      formatted_members_path(:format => 'json').should == "/members.json"
    end
    
    it "should route new_member_path() to /members/new" do
      new_member_path().should == "/members/new"
      formatted_new_member_path(:format => 'xml').should == "/members/new.xml"
      formatted_new_member_path(:format => 'json').should == "/members/new.json"
    end
    
    it "should route member_(:id => '1') to /members/1" do
      member_path(:id => '1').should == "/members/1"
      formatted_member_path(:id => '1', :format => 'xml').should == "/members/1.xml"
      formatted_member_path(:id => '1', :format => 'json').should == "/members/1.json"
    end
    
    it "should route edit_member_path(:id => '1') to /members/1/edit" do
      edit_member_path(:id => '1').should == "/members/1/edit"
    end
  end
  
end
