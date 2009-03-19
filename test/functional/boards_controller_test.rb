require File.dirname(__FILE__) + '/../test_helper'
require 'boards_controller'

# Re-raise errors caught by the controller.
class BoardsController; def rescue_action(e) raise e end; end

class BoardsControllerTest < Test::Unit::TestCase
  fixtures :boards

  def setup
    @controller = BoardsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:boards)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_board
    old_count = Board.count
    post :create, :board => { }
    assert_equal old_count+1, Board.count
    
    assert_redirected_to board_path(assigns(:board))
  end

  def test_should_show_board
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_board
    put :update, :id => 1, :board => { }
    assert_redirected_to board_path(assigns(:board))
  end
  
  def test_should_destroy_board
    old_count = Board.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Board.count
    
    assert_redirected_to boards_path
  end
end
