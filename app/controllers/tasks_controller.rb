class TasksController < ApplicationController

  before_filter :find_list
  respond_to :json
  
  def index
    render :json => @list.existing_tasks
  end
  
  def create
    @task = @list.tasks.new(params[:task])
    if @task.save
      render :json => @task
    else
      render :json => { :errors => @task.errors.full_messages }, :status => 422
    end
  end

  def show
    @task = @list.tasks.find(params[:id])
    render :json => @task
  end

  def update
    @task = @list.tasks.find(params[:id])
    @task.update_attributes! params[:task]
    render :json => @task
  end

  def destroy
    @task = @list.existing_tasks.find(params[:id])
    if @task.delete!
      render :json => true
    else
      render :json => 'Permission denied'
    end
  end
  
  private
  
  def find_list
    @list = List.find_by_slug(params[:list_id])
  end

end
