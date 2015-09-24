class ListsController < ApplicationController
  respond_to :json, :html

  def new
    list = stack.lists.new

    if list.save
      redirect_to stack_list_path(stack, list)
    else
      redirect_to stack
    end
  end

  def index
    if stack
      respond_to do |format|
        format.json { render json: stack.lists }
        format.html { render 'stacks/show' }
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def show
    respond_to do |format|
      format.json { render json: list }
      format.html { render 'stacks/show' }
    end
  end

  def create
    list = lists_scope.new(list_params)

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
    lists_scope.find_by_token(params[:id])
  end

  def lists_scope
    stack.try(:lists) || List
  end

  def stack
    params[:stack_id] ? Stack.find_by_token(params[:stack_id]) : nil
  end  

end
