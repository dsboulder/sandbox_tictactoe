# require File.join(File.dirname(__FILE__), "..", "..", "..", "..", "config", "environment")
# require 'test/unit'
# require "mocha"
# gem "acts_as_runnable_code"
# require "acts_as_runnable_code"
# 
# class WrappedClass
#   acts_as_wrapped_class
# end
# 
# class RunnableCode
#   acts_as_runnable_code :classes => [:wrapped_class]
# end
# 
# class AARCORController < ActionController::Base
# end
# 
# class AARCORView < ActionView::Base
# end
# 
# class ActsAsRunnableCodeOnRailsTest < Test::Unit::TestCase
#   # Replace this with your real tests.
#   def test_view_helper
#     view = AARCORView.new
#   end
#   
#   def test_controller
#     c = AARCORController.new
#     c.class_eval("acts_as_runnable_code_syntax_highlight_actions_for('RunnableCode')")
#   end
# end
