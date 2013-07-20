require 'test_helper'

class ShortnrControllerTest < ActionController::TestCase
  test "should get shorten" do
    get :shorten
    assert_response :success
  end

end
