class ListsController < ApplicationController

  respond_to :html, :xml, :json

  def index
    @lists = List.all
  end

  def new
  	@list = List.new
  end

  def create
    @list = List.new(params[:list])
    if @list.save
      flash[:notice] = "saved!"
      respond_with(@list, :location => list_url(@list))
    else
      flash[:error] = "Couldn't create."
      redirect_to new_list_url
    end
  end

  def show
    @list = List.find_by_slug(params[:id]) #find(params[:id])#
    @task = @list.tasks.new

    respond_to do |format|
      format.json { render :json => @list.tasks }
      format.html { render }
    end
  end

  def edit
    @list = List.find_by_slug(params[:id])
  end
  
  def update
    @list = List.find_by_slug(params[:id])
    if @list.update_attributes(params[:list])
      flash[:notice] = "List updated."
      respond_with(@list, :location => list_url(@list))
    else
      flash[:error] = "Could not update list"
      redirect_to edit_list_path(@list)
    end
  end
  
  def destroy
    @list = List.find_by_slug(params[:id])
    if @list.destroy
      flash[:notice] = "List deleted"
      redirect_to lists_url
    else
      flash[:error] = "Could not delete list. Have you done everything?"
      redirect_to lists_url
    end
  end

end
