class BoardsController < ApplicationController
  # GET /boards
  # GET /boards.xml
  def index
    @boards = Board.find(:all, :limit => 20, :order => "id DESC")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @boards.to_xml }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @board.to_xml }
    end
  end

  # GET /boards/new
  def new
    @board = Board.new
  end

  # GET /boards/1;edit
  def edit
    @board = Board.find(params[:id])
    
    while !@board.human_turn? && !@board.game_over?
      @board.make_computer_move!      
    end    
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to edit_board_url(@board) }
        format.xml  { head :created, :location => board_url(@board) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors.to_xml }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to board_url(@board) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors.to_xml }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url }
      format.xml  { head :ok }
    end
  end
  
  def move
    @board = Board.find(params[:id])
    move = @board.make_move!(params[:x_pos].to_i, params[:y_pos].to_i)
    @board.flush_log!
    @board.save
    
    @board.reload
    
    while !@board.human_turn? && !@board.game_over?
      @board.make_computer_move!      
    end
    redirect_to edit_board_path(@board)
  end
end
