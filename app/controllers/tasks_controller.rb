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
      render json: @task.errors, status: :unprocessable_entity
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
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = @list.tasks.find(params[:id])
    if @task.destroy
      head :no_content
    else
      render json: 'Permission denied'
    end
  end
  
  private

  def task_params
    params.require(:task).permit(:description, :completed, :sort_order)
  end  

  def find_list
    @list = (@stack ? @stack.lists : List).find_by_token(params[:list_id])

    if !@list
      raise ActiveRecord::RecordNotFound
    end
  end

  def find_stack
    if params[:stack_id]
      @stack = Stack.find_by_token(params[:stack_id])
    end
  end

end
