class ListsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  before_filter :find_stack
  respond_to :json, :html

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
    @list = find_list
    respond_with @list
  end

  def create
    if @stack
      @list = @stack.lists.new(list_params)
    else
      @list = List.new(list_params)
    end

    if @list.save
      render :json => @list, :status => :created
    else
      render :json => { :errors => @list.errors.full_messages }, :status => 422
    end
  end
  
  def update
    @list = find_list
    if @list.update_attributes(list_params)
      #override the default respond_with behavoir to always send back the model with update
      render :json => @list
    else
      flash[:error] = "Could not update list"
      redirect_to edit_stack_list_path(@stack, @list)
    end
  end
  
  def destroy
    @list = find_list
    if @list.destroy
      render :json => {}, :status => 204
    else
      render :json => 'Permission denied'
    end
  end

  private

  def list_params
    # dont `require(:list)` because we want to accept empty bodies on /create for now
    params.permit(:name)
  end

  def find_list
    if @stack
      @stack.lists.find_by_slug(params[:id].to_s)
    else
      # todo: change from id to uuid
      List.find(params[:id].to_i)
    end
  end

  def find_stack
    if params[:stack_id]
      @stack = Stack.find_by_token(params[:stack_id].to_s)
    end
  end

  def record_not_found
    render :json => {error: "record not found"}, :status => 404
  end
end
