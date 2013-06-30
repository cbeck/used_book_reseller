module AuthenticatedTestHelper
  # Sets the current member in the session from the member fixtures.
  def login_as(member)
    @request.session[:member_id] = member ? members(member).id : nil
  end

  def authorize_as(member)
    @request.env["HTTP_AUTHORIZATION"] = member ? ActionController::HttpAuthentication::Basic.encode_credentials(members(member).login, 'monkey') : nil
  end
  
  # rspec
  def mock_member
    member = mock_model(Member, :id => 1,
      :login  => 'user_name',
      :name   => 'U. Surname',
      :to_xml => "Member-in-XML", :to_json => "Member-in-JSON", 
      :errors => [])
    member
  end  
end
