# Include this is test_helper.rb to enable test-case helper support for RoleRequirement via:
#   include RoleRequirementTestHelper
#
# RoleRequirementTestHelper uses the power of ruby to temporarily "hijack" your target action.  (don't worry, it puts things back the way it was after it runs)
# This means that the only thing that will be tested is whether or not the action can be accessed with a given circumstances.
# Any authentication you implement inside of your action will be ignored.
#
module RoleRequirementTestHelper

  # Makes sure a member can access the given action
  #
  # Example:
  #
  #   assert_member_can_access(:quentin, "index")
  # 
  def assert_member_can_access(member, actions, params = {})
    assert_member_access_check(true, member, actions, params)
  end
  
  # Makes sure a member cant access the given action
  #
  # Example:
  #
  #   assert_member_cant_access(:quentin, "destroy", :listing_id => 1)
  # 
  def assert_member_cant_access(member, actions, params = {})
    assert_member_access_check(false, member, actions, params)
  end
  
  # Check a list of members against a set of actions with parameters.
  # 
  # Parameters:
  #   members_access_list - a hash where the key is the label for a fixture, and the value is a boolean.
  #   actions - a list of actions to test against
  #   params - a hash containing the parameters to pass to each test call to the controller.
  # 
  # Example:
  #   assert_member_access(
  #     {:admin => true, :quentin => false }, 
  #     [:show, :edit], 
  #     {:listing_id => 1})
  def assert_members_access(members_access_list, actions, params = {})
    members_access_list.each_pair {|member, access| 
      assert_member_access_check(access, member, actions, params)
    }
  end
  
  alias :assert_member_cannot_access :assert_member_cant_access

private
  def assert_member_access_check(should_access, member, actions, params = {})
    params = HashWithIndifferentAccess.new(params)
    
    (Array===actions ? actions : [actions]).each { |action|
      # reset the controller, request, and response
      @controller = @controller.class.new
      @request = @request.class.new
      @response = @response.class.new
      login_as member
      if should_access
        assert request_passes_role_security_system?(action, params), "request to #{@controller.class}##{action} with member #{member} and params #{params.inspect} should have passed "
      else
        assert ! request_passes_role_security_system?(action, params), "request to #{@controller.class}##{action} with member #{member} and params #{params.inspect} should have been denied"
      end
    }
  end
  
  # This is the core of the test system.
  def request_passes_role_security_system?(action, params)
    did_it_pass = false
    
    action = action.to_s
    hijacker = Hijacker.new(@controller.class)
    
    begin
      assert hijacker.hijack_instance_method(action, "@last_action_passed='#{action}'; render :text => 'passed'"), "unable to hijack method '#{action}'.  Are you sure the action exists?"
      get action, params
    rescue
      assert false, "error occurred while trying to access action '#{action}' -- #{$!.to_s}.\nCheck to make sure that you are passing needed parameters.\n#{$!.backtrace * "\n"} "
    ensure
      hijacker.restore
    end
    
    did_it_pass = (action.to_s == assigns(:last_action_passed)) # make sure it actually made it through
  end
end
