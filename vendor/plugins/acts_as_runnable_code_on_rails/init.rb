# Include hook code here

require "acts_as_runnable_code"

ActionView::Base.send(:include, ActsAsRunnableCodeOnRails::ViewHelpers)
ActionController::Base.send(:extend, ActsAsRunnableCodeOnRails::ControllerHelpers)