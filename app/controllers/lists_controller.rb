class ListsController < ApplicationController
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
      redirect_to list_url(@list)
    else
      flash[:error] = "Couldn't create."
      redirect_to new_list_url
    end
  end

  def show
    @list = List.find(params[:id])
  end

end
