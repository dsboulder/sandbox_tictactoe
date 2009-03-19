class Move < ActiveRecord::Base
  belongs_to :board
  
  validates_uniqueness_of :x_pos, :scope => [:board_id, :y_pos]
  validates_uniqueness_of :y_pos, :scope => [:board_id, :x_pos]
  
  validates_inclusion_of :x_pos, :in => [0,1,2]
  validates_inclusion_of :y_pos, :in => [0,1,2]
  
  acts_as_wrapped_class :methods => [:x_pos, :y_pos, :is_x, :created_at]
end
