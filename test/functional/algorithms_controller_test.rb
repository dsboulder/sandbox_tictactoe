require File.dirname(__FILE__) + '/../test_helper'
require 'algorithms_controller'

# Re-raise errors caught by the controller.
class AlgorithmsController; def rescue_action(e) raise e end; end

class AlgorithmsControllerTest < Test::Unit::TestCase
  fixtures :algorithms

  def setup
    @controller = AlgorithmsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:algorithms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_algorithm
    old_count = Algorithm.count
    post :create, :algorithm => { }
    assert_equal old_count+1, Algorithm.count
    
    assert_redirected_to algorithm_path(assigns(:algorithm))
  end

  def test_should_show_algorithm
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_algorithm
    put :update, :id => 1, :algorithm => { }
    assert_redirected_to algorithm_path(assigns(:algorithm))
  end
  
  def test_should_destroy_algorithm
    old_count = Algorithm.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Algorithm.count
    
    assert_redirected_to algorithms_path
  end
end
