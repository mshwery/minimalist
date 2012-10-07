class ListsController < ApplicationController

  before_filter :find_stack
  respond_to :html, :xml, :json

  def new
  	@list = @stack.lists.new

    if @list.save
      redirect_to stack_list_url(@stack, @list)
    else
      redirect_to @stack
    end
  end

  def index
    respond_with @stack.lists
  end

  def show
    @list = @stack.lists.find_by_slug(params[:id])
    respond_with @list
  end
  
  def update
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.update_attributes(params[:list])
      #override the default respond_with behavoir to always send back the model with update
      render :json => @list, :status => :created
    else
      raise @list.inspect
      flash[:error] = "Could not update list"
      redirect_to edit_stack_list_path(@stack, @list)
    end
  end
  
  def destroy
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.destroy
      render :json => true
    else
      flash[:error] = "Could not delete list."
      redirect_to stack_url(@stack)
    end
  end

  def find_stack
    @stack = Stack.find_or_create_by_token(params[:stack_id])
  end
end
