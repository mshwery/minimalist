class ListsController < ApplicationController

  before_filter :find_stack
  respond_to :html, :xml, :json

  def new
  	@list = @stack.lists.new
  end

  def create
    @list = @stack.lists.new(params[:list])
    if @list.save
      flash[:notice] = "saved!"
      respond_with(@list, :location => stack_list_url(@stack, @list))
    else
      flash[:error] = "Couldn't create."
      redirect_to new_stack_list_url(@stack)
    end
  end

  def show
    @list = @stack.lists.find_by_slug(params[:id]) #find(params[:id])#
    respond_with @list
  end
  
  def edit
    @list = @stack.lists.find_by_slug(params[:id])
  end
  
  def update
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.update_attributes(params[:list])
      #flash[:notice] = "List updated."
      respond_with(@list, :location => stack_list_url(@stack, @list))
    else
      flash[:error] = "Could not update list"
      redirect_to edit_stack_list_path(@stack, @list)
    end
  end
  
  def destroy
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.destroy
      flash[:notice] = "List deleted"
      redirect_to stack_url(@stack)
    else
      flash[:error] = "Could not delete list. Have you done everything?"
      redirect_to stack_url(@stack)
    end
  end

  def find_stack
    @stack = Stack.find_or_create_by_token(params[:stack_id])
  end
end
