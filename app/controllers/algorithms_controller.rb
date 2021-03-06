class AlgorithmsController < ApplicationController
  
  # GET /algorithms
  # GET /algorithms.xml
  def index
    @algorithms = Algorithm.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @algorithms.to_xml }
    end
  end

  # GET /algorithms/1
  # GET /algorithms/1.xml
  def show
    @algorithm = Algorithm.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @algorithm.to_xml }
    end
  end

  # GET /algorithms/new
  def new
    @algorithm = Algorithm.new
  end

  # GET /algorithms/1;edit
  def edit
    @algorithm = Algorithm.find(params[:id])
  end

  # POST /algorithms
  # POST /algorithms.xml
  def create
    @algorithm = Algorithm.new(params[:algorithm])

    respond_to do |format|
      if @algorithm.save
        flash[:notice] = 'Algorithm was successfully created.'
        format.html { redirect_to algorithm_url(@algorithm) }
        format.xml  { head :created, :location => algorithm_url(@algorithm) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @algorithm.errors.to_xml }
      end
    end
  end

  # PUT /algorithms/1
  # PUT /algorithms/1.xml
  def update
    @algorithm = Algorithm.find(params[:id])

    respond_to do |format|
      if @algorithm.update_attributes(params[:algorithm])
        flash[:notice] = 'Algorithm was successfully updated.'
        format.html { redirect_to algorithm_url(@algorithm) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @algorithm.errors.to_xml }
      end
    end
  end

  # # DELETE /algorithms/1
  # # DELETE /algorithms/1.xml
  # def destroy
  #   @algorithm = Algorithm.find(params[:id])
  #   @algorithm.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to algorithms_url }
  #     format.xml  { head :ok }
  #   end
  # end
end
