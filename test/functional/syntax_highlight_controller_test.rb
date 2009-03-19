require File.dirname(__FILE__) + '/../test_helper'
require 'syntax_highlight_controller'

# Re-raise errors caught by the controller.
class SyntaxHighlightController; def rescue_action(e) raise e end; end

class SyntaxHighlightControllerTest < Test::Unit::TestCase
  def setup
    @controller = SyntaxHighlightController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
