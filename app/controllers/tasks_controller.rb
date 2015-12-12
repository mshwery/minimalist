class TasksController < ApplicationController
  respond_to :json

  before_action :redirect_current_user
  before_action :find_stack
  before_action :find_list
  
  def index
    tasks = @list.tasks
    render json: tasks
  end
  
  def create
    task = @list.tasks.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def show
    task = @list.tasks.find(params[:id])
    render json: task
  end
  
  def update
    task = @list.tasks.find(params[:id])

    if task.update_attributes(task_params)
      render json: task
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = @list.tasks.find(params[:id])
    if task.destroy
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
    @list ||= @stack.lists.find_by_token(params[:list_id])
    record_not_found unless @list
  end

  def find_stack
    @stack ||= Stack.find_by(token: params[:stack_id])
    record_not_found unless @stack
  end

end
