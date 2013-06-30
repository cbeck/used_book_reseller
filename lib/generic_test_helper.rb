module GenericTestHelper
  def assert_difference(object, method, difference=1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference,
      object.send(method)
  end
  
  def assert_no_difference(object, method, block)
    assert_difference object, method, 0, &block
  end
end