require 'test_helper'

class AccessTypesControllerTest < ActionController::TestCase
  setup do
    @access_type = access_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:access_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create access_type" do
    assert_difference('AccessType.count') do
      post :create, access_type: { description: @access_type.description, name: @access_type.name }
    end

    assert_redirected_to access_type_path(assigns(:access_type))
  end

  test "should show access_type" do
    get :show, id: @access_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @access_type
    assert_response :success
  end

  test "should update access_type" do
    patch :update, id: @access_type, access_type: { description: @access_type.description, name: @access_type.name }
    assert_redirected_to access_type_path(assigns(:access_type))
  end

  test "should destroy access_type" do
    assert_difference('AccessType.count', -1) do
      delete :destroy, id: @access_type
    end

    assert_redirected_to access_types_path
  end
end
