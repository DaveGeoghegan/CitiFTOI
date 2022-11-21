require 'test_helper'

class InputScreensControllerTest < ActionController::TestCase
  setup do
    @input_screen = input_screens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_screens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_screen" do
    assert_difference('InputScreen.count') do
      post :create, input_screen: { name: @input_screen.name, navigation_label: @input_screen.navigation_label }
    end

    assert_redirected_to input_screen_path(assigns(:input_screen))
  end

  test "should show input_screen" do
    get :show, id: @input_screen
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_screen
    assert_response :success
  end

  test "should update input_screen" do
    patch :update, id: @input_screen, input_screen: { name: @input_screen.name, navigation_label: @input_screen.navigation_label }
    assert_redirected_to input_screen_path(assigns(:input_screen))
  end

  test "should destroy input_screen" do
    assert_difference('InputScreen.count', -1) do
      delete :destroy, id: @input_screen
    end

    assert_redirected_to input_screens_path
  end
end
