require 'test_helper'

class AdicionalesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get adicionales_index_url
    assert_response :success
  end

  test "should get show" do
    get adicionales_show_url
    assert_response :success
  end

  test "should get new" do
    get adicionales_new_url
    assert_response :success
  end

  test "should get create" do
    get adicionales_create_url
    assert_response :success
  end

  test "should get edit" do
    get adicionales_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get adicionales_destroy_url
    assert_response :success
  end

end
