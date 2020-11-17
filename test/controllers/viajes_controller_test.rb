require 'test_helper'

class ViajesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get viajes_index_url
    assert_response :success
  end

  test "should get new" do
    get viajes_new_url
    assert_response :success
  end

  test "should get create" do
    get viajes_create_url
    assert_response :success
  end

  test "should get show" do
    get viajes_show_url
    assert_response :success
  end

  test "should get update" do
    get viajes_update_url
    assert_response :success
  end

  test "should get edit" do
    get viajes_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get viajes_destroy_url
    assert_response :success
  end

end
