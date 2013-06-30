require File.dirname(__FILE__) + '/../test_helper'

class AccountTypeTest < Test::Unit::TestCase
  fixtures :account_types

  def test_is_account_type_free
    freebie = account_types(:free)
    assert freebie.is_free?
    not_freebie = account_types(:not_free)
    assert !not_freebie.is_free?
  end
end
