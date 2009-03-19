class SyntaxHighlightController < ApplicationController
  acts_as_runnable_code_syntax_highlight_actions_for("Algorithm")
  
end
