class TasksController < ApplicationController
  before_filter :find_stack, :find_list
  respond_to :json
  
  def index
    render json: @list.tasks
  end
  
  def create
    @task = @list.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: { :errors => @task.errors.full_messages }, status: 422
    end
  end

  def show
    @task = @list.tasks.find(params[:id])
    render json: @task
  end
  
  def update
    @task = @list.tasks.find(params[:id])

    if @task.update_attributes(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: 422
    end
  end

  def destroy
    @task = @list.tasks.find(params[:id])
    if @task.destroy
      render json: {}, status: 204
    else
      render json: 'Permission denied'
    end
  end
  
  private

  def task_params
    params.require(:task).permit(:description, :completed, :sort_order)
  end  

  def find_list
    if @stack
      @list = @stack.lists.find_by_slug(params[:list_id].to_s)
    else
      # todo: change from id to uuid
      @list = List.find(params[:list_id].to_i)
    end
  end

  def find_stack
    if params[:stack_id]
      @stack = Stack.find_by_token(params[:stack_id].to_s)
    end
  end

end
