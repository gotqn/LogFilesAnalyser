require 'test_helper'

class LogFilesControllerTest < ActionController::TestCase
  setup do
    @log_file = log_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:log_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create log_file" do
    assert_difference('LogFile.count') do
      post :create, log_file: { description: @log_file.description, name: @log_file.name }
    end

    assert_redirected_to log_file_path(assigns(:log_file))
  end

  test "should show log_file" do
    get :show, id: @log_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @log_file
    assert_response :success
  end

  test "should update log_file" do
    patch :update, id: @log_file, log_file: { description: @log_file.description, name: @log_file.name }
    assert_redirected_to log_file_path(assigns(:log_file))
  end

  test "should destroy log_file" do
    assert_difference('LogFile.count', -1) do
      delete :destroy, id: @log_file
    end

    assert_redirected_to log_files_path
  end
end
