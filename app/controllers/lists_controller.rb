class ListsController < ApplicationController
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
    if @stack
      render json: @stack.lists
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def show
    @list = find_list
    render json: @list
  end

  def create
    if @stack
      @list = @stack.lists.new(list_params)
    else
      @list = List.new(list_params)
    end

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end
  
  def update
    @list = find_list
    if @list.update_attributes(list_params)
      #override the default respond_with behavoir to always send back the model with update
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    @list = find_list
    if @list.destroy
      head :no_content
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  private

  def list_params
    # dont `require(:list)` because we want to accept empty bodies on /create for now
    params.permit(:name)
  end

  def find_list
    (@stack ? @stack.lists : List).find_by_token(params[:id]) or raise ActiveRecord::RecordNotFound
  end

  def find_stack
    if params[:stack_id]
      @stack = Stack.find_by_token(params[:stack_id].to_s)
    end
  end

end
