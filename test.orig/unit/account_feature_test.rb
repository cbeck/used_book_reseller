require File.dirname(__FILE__) + '/../test_helper'

class AccountFeatureTest < Test::Unit::TestCase
  fixtures :account_features, :account_features_account_types

  def test_should_get_account_type
    @account_types = account_features(:first).account_types
    assert_not_nil @account_types
  end
end
