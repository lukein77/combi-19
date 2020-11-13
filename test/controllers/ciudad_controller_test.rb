require 'test_helper'

class CiudadControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ciudad_index_url
    assert_response :success
  end

  test "should get new" do
    get ciudad_new_url
    assert_response :success
  end

  test "should get create" do
    get ciudad_create_url
    assert_response :success
  end

  test "should get destroy" do
    get ciudad_destroy_url
    assert_response :success
  end

end
