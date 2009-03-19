class Board < ActiveRecord::Base
  has_many :moves
  belongs_to :algorithm_x, :class_name => "Algorithm", :foreign_key => "algorithm_x_id"
  belongs_to :algorithm_o, :class_name => "Algorithm", :foreign_key => "algorithm_o_id"
  
  attr_reader :already_moved
  
  after_create :initial_message
  
  acts_as_wrapped_class :methods => [:moves, :make_move!, :move_matrix, :turn, :log_info, :log_error]
  
  def make_move!(x, y)
    raise "Invalid move" if @already_moved
    m = moves.create(:x_pos => x, :y_pos => y, :is_x => turn == "x")
    if m
      @alread_moved = true
      log_info("#{m.is_x ? 'X' : 'O'} moved to #{m.x_pos},#{m.y_pos}")
    else
      raise "Invalid move"
    end
  end
  
  def log_messages
    @log_messages ||= []
  end
  
  def log_info(msg)    
    msg = {:message => msg, :level => :info, :time => Time.now}
    self.history ||= ""
    self.history += "#{msg[:time].strftime("%H:%M:%S") + (".%.06d" % msg[:time].tv_usec)} #{msg[:level].to_s.upcase}: #{msg[:message]}\n"
    self.save     
    logger.info  "+++ #{msg}"
  end
  
  def log_error(msg)
    msg =  {:message => msg, :level => :error, :time => Time.now}    
    self.history ||= ""
    self.history += "#{msg[:time].strftime("%H:%M:%S") + (".%.06d" % msg[:time].tv_usec)} #{msg[:level].to_s.upcase}: #{msg[:message]}\n"
    self.save     
    logger.error  "+++ #{msg}"
  end
  
  def flush_log!
    # log_messages.each do |msg|
    #   self.history ||= ""
    #   self.history += "#{msg[:time].strftime("%H:%M:%S") + (".%.06d" % msg[:time].tv_usec)} #{msg[:level].to_s.upcase}: #{msg[:message]}\n"
    # end
    # log_messages = []
  end
  
  def turn
    moves.count % 2 == 0 ? "x" : "o"
  end
  
  def move_matrix
    matrix = [[""] * 3] + [[""] * 3] + [[""] * 3]
    moves.each do |move|
      matrix[move.x_pos][move.y_pos] = move.is_x ? "x" : "o"
    end
    matrix
  end
  
  def game_over?
    cats_game? || !winner.blank?
  end
  
  def winner
    return self.forfeit == "x" ? "o" : "x" unless self.forfeit.blank?
    matrix = move_matrix
    0.upto(2) do |x|
      last = nil
      0.upto(2) do |y|
        if !last || matrix[x][y] == last
          last = matrix[x][y]
        else
          last = nil
          break
        end
      end
      return last if last
    end

    0.upto(2) do |y|
      last = nil
      0.upto(2) do |x|
        if !last || matrix[x][y] == last
          last = matrix[x][y]
        else
          last = nil
          break
        end
      end
      return last if last
    end

    last = nil
    0.upto(2) do |xy|
      if !last || matrix[xy][xy] == last
        last = matrix[xy][xy]
      else
        last = nil
        break
      end
    end
    return last if last

    last = nil
    0.upto(2) do |xy|
      if !last || matrix[2-xy][xy] == last
        last = matrix[2-xy][xy]
      else
        last = nil
        break
      end
    end
    return last if last
    
    nil
  end
  
  def cats_game?
    move_matrix.each do |row|
      row.each do |cell|
        return false if cell.blank?
      end
    end
    true
  end
  
  def last_move
    @last_move ||= moves.find(:first, :order => "id DESC")
  end
  
  def initial_message
    log_info("Board created")
    flush_log!    
  end
  
  def human_turn?
    turn == "x" ? algorithm_x.nil? : algorithm_o.nil?
  end
  
  def make_computer_move!
    logger.debug "BEGINNING make_computer_move!"
    old_move_cnt = moves.count
    algorithm = (turn == "x") ? algorithm_x : algorithm_o
    begin
      logger.debug "--- running code..."      
      algorithm.run_code(self, :timeout => 1.0)
      logger.debug "--- running code completed success!"      
    rescue
      log_error("Running make_computer_move! #{$!}")
      logger.warn "--- running code completed failure: #{$!} #{$!.backtrace.join("\n")}"      
    ensure
      flush_log!
      self.save
      
      self.reload

      if old_move_cnt == moves.count
        self.update_attribute(:forfeit, turn) 
        log_info("#{turn.upcase} forfeits because no move was made")
      end
      flush_log!
      self.save      
      logger.debug "--- flushed log and saved"
    end
    logger.debug "ENDING make_computer_move!"
  end
end
