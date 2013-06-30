# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe Member do
  fixtures :members

  describe 'being created' do
    before do
      @member = nil
      @creating_member = lambda do
        @member = create_member
        violated "#{@member.errors.full_messages.to_sentence}" if @member.new_record?
      end
    end

    it 'increments Member#count' do
      @creating_member.should change(Member, :count).by(1)
    end

    it 'initializes #activation_code' do
      @creating_member.call
      @member.reload
      @member.activation_code.should_not be_nil
    end

    it 'starts in pending state' do
      @creating_member.call
      @member.reload
      @member.should be_pending
    end
  end

  #
  # Validations
  #

  it 'requires login' do
    lambda do
      u = create_member(:login => nil)
      u.errors.on(:login).should_not be_nil
    end.should_not change(Member, :count)
  end

  describe 'allows legitimate logins:' do
    ['123', '1234567890_234567890_234567890_234567890',
     'hello.-_there@funnychar.com'].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = create_member(:login => login_str)
          u.errors.on(:login).should     be_nil
        end.should change(Member, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate logins:' do
    ['12', '1234567890_234567890_234567890_234567890_', "tab\t", "newline\n",
     "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
     'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = create_member(:login => login_str)
          u.errors.on(:login).should_not be_nil
        end.should_not change(Member, :count)
      end
    end
  end

  it 'requires password' do
    lambda do
      u = create_member(:password => nil)
      u.errors.on(:password).should_not be_nil
    end.should_not change(Member, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = create_member(:password_confirmation => nil)
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(Member, :count)
  end

  it 'requires email' do
    lambda do
      u = create_member(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(Member, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
     'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
     'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
     'domain@can.haz.many.sub.doma.in', 'student.name@university.edu'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_member(:email => email_str)
          u.errors.on(:email).should     be_nil
        end.should change(Member, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
     'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
     'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
     # these are technically allowed but not seen in practice:
     'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_member(:email => email_str)
          u.errors.on(:email).should_not be_nil
        end.should_not change(Member, :count)
      end
    end
  end

  describe 'allows legitimate names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
     '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_member(:name => name_str)
          u.errors.on(:name).should     be_nil
        end.should change(Member, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_member(:name => name_str)
          u.errors.on(:name).should_not be_nil
        end.should_not change(Member, :count)
      end
    end
  end

  it 'resets password' do
    members(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    Member.authenticate('quentin', 'new password').should == members(:quentin)
  end

  it 'does not rehash password' do
    members(:quentin).update_attributes(:login => 'quentin2')
    Member.authenticate('quentin2', 'monkey').should == members(:quentin)
  end

  #
  # Authentication
  #

  it 'authenticates member' do
    Member.authenticate('quentin', 'monkey').should == members(:quentin)
  end

  it "doesn't authenticate member with bad password" do
    Member.authenticate('quentin', 'invalid_password').should be_nil
  end

 if REST_AUTH_SITE_KEY.blank?
   # old-school passwords
   it "authenticates a user against a hard-coded old-style password" do
     Member.authenticate('old_password_holder', 'test').should == members(:old_password_holder)
   end
 else
   it "doesn't authenticate a user against a hard-coded old-style password" do
     Member.authenticate('old_password_holder', 'test').should be_nil
   end

   # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
   desired_encryption_expensiveness_ms = 0.1
   it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
     test_reps = 100
     start_time = Time.now; test_reps.times{ Member.authenticate('quentin', 'monkey'+rand.to_s) }; end_time   = Time.now
     auth_time_ms = 1000 * (end_time - start_time)/test_reps
     auth_time_ms.should > desired_encryption_expensiveness_ms
   end
 end

  #
  # Authentication
  #

  it 'sets remember token' do
    members(:quentin).remember_me
    members(:quentin).remember_token.should_not be_nil
    members(:quentin).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    members(:quentin).remember_me
    members(:quentin).remember_token.should_not be_nil
    members(:quentin).forget_me
    members(:quentin).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    members(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    members(:quentin).remember_token.should_not be_nil
    members(:quentin).remember_token_expires_at.should_not be_nil
    members(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    members(:quentin).remember_me_until time
    members(:quentin).remember_token.should_not be_nil
    members(:quentin).remember_token_expires_at.should_not be_nil
    members(:quentin).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    members(:quentin).remember_me
    after = 2.weeks.from_now.utc
    members(:quentin).remember_token.should_not be_nil
    members(:quentin).remember_token_expires_at.should_not be_nil
    members(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'registers passive member' do
    member = create_member(:password => nil, :password_confirmation => nil)
    member.should be_passive
    member.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    member.register!
    member.should be_pending
  end

  it 'suspends member' do
    members(:quentin).suspend!
    members(:quentin).should be_suspended
  end

  it 'does not authenticate suspended member' do
    members(:quentin).suspend!
    Member.authenticate('quentin', 'monkey').should_not == members(:quentin)
  end

  it 'deletes member' do
    members(:quentin).deleted_at.should be_nil
    members(:quentin).delete!
    members(:quentin).deleted_at.should_not be_nil
    members(:quentin).should be_deleted
  end

  describe "being unsuspended" do
    fixtures :members

    before do
      @member = members(:quentin)
      @member.suspend!
    end

    it 'reverts to active state' do
      @member.unsuspend!
      @member.should be_active
    end

    it 'reverts to passive state if activation_code and activated_at are nil' do
      Member.update_all :activation_code => nil, :activated_at => nil
      @member.reload.unsuspend!
      @member.should be_passive
    end

    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      Member.update_all :activation_code => 'foo-bar', :activated_at => nil
      @member.reload.unsuspend!
      @member.should be_pending
    end
  end

protected
  def create_member(options = {})
    record = Member.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
