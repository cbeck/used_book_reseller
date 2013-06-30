require File.dirname(__FILE__) + '/../spec_helper'
include ApplicationHelper
include MembersHelper
include AuthenticatedTestHelper

describe MembersHelper do
  before do
    @member = mock_member
  end
  
  describe "if_authorized" do 
    it "yields if authorized" do
      should_receive(:authorized?).with('a','r').and_return(true)
      if_authorized?('a','r'){|action,resource| [action,resource,'hi'] }.should == ['a','r','hi']
    end
    it "does nothing if not authorized" do
      should_receive(:authorized?).with('a','r').and_return(false)
      if_authorized?('a','r'){ 'hi' }.should be_nil
    end
  end
  
  describe "link_to_member" do
    it "should give an error on a nil member" do
      lambda { link_to_member(nil) }.should raise_error('Invalid member')
    end
    it "should link to the given member" do
      should_receive(:member_path).at_least(:once).and_return('/members/1')
      link_to_member(@member).should have_tag("a[href='/members/1']")
    end
    it "should use given link text if :content_text is specified" do
      link_to_member(@member, :content_text => 'Hello there!').should have_tag("a", 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      link_to_member(@member).should have_tag("a", 'user_name')
    end
    it "should use the name as link text with :content_method => :name" do
      link_to_member(@member, :content_method => :name).should have_tag("a", 'U. Surname')
    end
    it "should use the login as title with no :title_method specified" do
      link_to_member(@member).should have_tag("a[title='user_name']")
    end
    it "should use the name as link title with :content_method => :name" do
      link_to_member(@member, :title_method => :name).should have_tag("a[title='U. Surname']")
    end
    it "should have nickname as a class by default" do
      link_to_member(@member).should have_tag("a.nickname")
    end
    it "should take other classes and no longer have the nickname class" do
      result = link_to_member(@member, :class => 'foo bar')
      result.should have_tag("a.foo")
      result.should have_tag("a.bar")
    end
  end

  describe "link_to_login_with_IP" do
    it "should link to the login_path" do
      link_to_login_with_IP().should have_tag("a[href='/login']")
    end
    it "should use given link text if :content_text is specified" do
      link_to_login_with_IP('Hello there!').should have_tag("a", 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      link_to_login_with_IP().should have_tag("a", '0.0.0.0')
    end
    it "should use the ip address as title" do
      link_to_login_with_IP().should have_tag("a[title='0.0.0.0']")
    end
    it "should by default be like school in summer and have no class" do
      link_to_login_with_IP().should_not have_tag("a.nickname")
    end
    it "should have some class if you tell it to" do
      result = link_to_login_with_IP(nil, :class => 'foo bar')
      result.should have_tag("a.foo")
      result.should have_tag("a.bar")
    end
    it "should have some class if you tell it to" do
      result = link_to_login_with_IP(nil, :tag => 'abbr')
      result.should have_tag("abbr[title='0.0.0.0']")
    end
  end

  describe "link_to_current_member, When logged in" do
    before do
      stub!(:current_member).and_return(@member)
    end
    it "should link to the given member" do
      should_receive(:member_path).at_least(:once).and_return('/members/1')
      link_to_current_member().should have_tag("a[href='/members/1']")
    end
    it "should use given link text if :content_text is specified" do
      link_to_current_member(:content_text => 'Hello there!').should have_tag("a", 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      link_to_current_member().should have_tag("a", 'user_name')
    end
    it "should use the name as link text with :content_method => :name" do
      link_to_current_member(:content_method => :name).should have_tag("a", 'U. Surname')
    end
    it "should use the login as title with no :title_method specified" do
      link_to_current_member().should have_tag("a[title='user_name']")
    end
    it "should use the name as link title with :content_method => :name" do
      link_to_current_member(:title_method => :name).should have_tag("a[title='U. Surname']")
    end
    it "should have nickname as a class" do
      link_to_current_member().should have_tag("a.nickname")
    end
    it "should take other classes and no longer have the nickname class" do
      result = link_to_current_member(:class => 'foo bar')
      result.should have_tag("a.foo")
      result.should have_tag("a.bar")
    end
  end

  describe "link_to_current_member, When logged out" do
    before do
      stub!(:current_member).and_return(nil)
    end
    it "should link to the login_path" do
      link_to_current_member().should have_tag("a[href='/login']")
    end
    it "should use given link text if :content_text is specified" do
      link_to_current_member(:content_text => 'Hello there!').should have_tag("a", 'Hello there!')
    end
    it "should use 'not signed in' as link text with no :content_method specified" do
      link_to_current_member().should have_tag("a", 'not signed in')
    end
    it "should use the ip address as title" do
      link_to_current_member().should have_tag("a[title='0.0.0.0']")
    end
    it "should by default be like school in summer and have no class" do
      link_to_current_member().should_not have_tag("a.nickname")
    end
    it "should have some class if you tell it to" do
      result = link_to_current_member(:class => 'foo bar')
      result.should have_tag("a.foo")
      result.should have_tag("a.bar")
    end
  end

end
