class TasksController < ApplicationController
  respond_to :json
  before_filter :stack
  
  def index
    tasks = list.tasks
    render json: tasks
  end
  
  def create
    task = list.tasks.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def show
    task = list.tasks.find(params[:id])
    render json: task
  end
  
  def update
    task = list.tasks.find(params[:id])

    if task.update_attributes(task_params)
      render json: task
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = list.tasks.find(params[:id])
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

  def list
    @list ||= lists_scope.find_by_token(params[:list_id])
  end

  def lists_scope
    @lists_scope ||= stack.try(:lists) || List.all
  end

  def stack
    return @stack if defined?(@stack)
    @stack = params[:stack_id] ? Stack.find_by(token: params[:stack_id]) : nil
  end

end
