class ListsController < ApplicationController
  respond_to :json, :html

  before_action :redirect_current_user, only: [:new]
  before_action :find_stack

  def new
    list = @stack.lists.new

    if list.save
      redirect_to stack_list_path(@stack, list)
    else
      redirect_to stack
    end
  end

  def index
    respond_to do |format|
      format.json { render json: @stack.lists }
      format.html { render 'stacks/show' }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: list }
      format.html { render 'stacks/show' }
    end
  end

  def create
    list = @stack.lists.new(list_params)

    if list.save
      render json: list, status: :created
    else
      render json: list.errors, status: :unprocessable_entity
    end
  end
  
  def update
    if list.update_attributes(list_params)
      #override the default respond_with behavoir to always send back the model with update
      render json: list
    else
      render json: list.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    if list.destroy
      head :no_content
    else
      render json: list.errors, status: :unprocessable_entity
    end
  end

  private

  def list_params
    # dont `require(:list)` because we want to accept empty bodies on /create for now
    params.permit(:name)
  end

  def list
    @list ||= @stack.lists.find_by_token(params[:id])
  end

  def find_stack
    @stack ||= Stack.find_by(token: params[:stack_id])
    if !@stack
      respond_to do |format|
        format.json { record_not_found }
        format.html { redirect_to :root }
      end
    end
  end

end
