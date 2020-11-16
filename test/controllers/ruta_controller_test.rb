require 'test_helper'

class RutaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ruta_index_url
    assert_response :success
  end

  test "should get new" do
    get ruta_new_url
    assert_response :success
  end

  test "should get create" do
    get ruta_create_url
    assert_response :success
  end

  test "should get edit" do
    get ruta_edit_url
    assert_response :success
  end

  test "should get show" do
    get ruta_show_url
    assert_response :success
  end

  test "should get update" do
    get ruta_update_url
    assert_response :success
  end

  test "should get destroy" do
    get ruta_destroy_url
    assert_response :success
  end

end
