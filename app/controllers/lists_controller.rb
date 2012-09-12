class ListsController < ApplicationController

  before_filter :find_stack
  respond_to :html, :xml, :json

  def new
  	@list = @stack.lists.new

    if @list.save
      redirect_to stack_list_url(@stack, @list)
    else
      redirect_to new_stack_list_url(@stack)
    end
  end

  def create
    @list = @stack.lists.new(params[:list])
    if @list.save
      respond_with(@list, :location => stack_list_url(@stack, @list))
    else
      redirect_to new_stack_list_url(@stack)
    end
  end

  def index
    respond_with @stack.lists
    # respond_to do |format|
    #   format.html { respond_with @stack.lists }
    #   format.json { render :json => @stack.lists.to_json, :callback => params[:callback] }
    # end
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
      #override the default respond_with behavoir to always send back the model with update
      respond_with(@list) do |format|
        format.json { render :json => @list, :status => :created, :location => stack_list_path(@stack, @list) }
      end
    else
      flash[:error] = "Could not update list"
      redirect_to edit_stack_list_path(@stack, @list)
    end
  end
  
  def destroy
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.destroy
      respond_with @list
    else
      flash[:error] = "Could not delete list. Have you done everything?"
      redirect_to stack_url(@stack)
    end
  end

  def find_stack
    @stack = Stack.find_or_create_by_token(params[:stack_id])
  end
end
