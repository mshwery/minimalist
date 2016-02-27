class Api::TasksController < Api::BaseController
  respond_to :json

  before_action :authenticate!
  before_action :find_list, :authorize_list
  before_action :find_task, only: [:show, :update, :destroy]

  def index
    tasks = @list.tasks
    render json: tasks
  end  

  def create
    task = @list.tasks.new(task_params)
    if task.save
      render json: task, status: :created
    else
      api_error(status: :unprocessable_entity, errors: task.errors)
    end
  end

  def show
    render json: @task
  end
  
  def update
    if @task.update_attributes(task_params)
      render json: @task
    else
      api_error(status: :unprocessable_entity, errors: @task.errors)
    end
  end

  def destroy
    if @task.destroy
      head :no_content
    else
      api_error(status: :unprocessable_entity, errors: @task.errors)
    end
  end

  private

    def task_params
      params.require(:task).permit(:description, :completed, :sort_order)
    end

    def find_task
      @task ||= @list.tasks.find(params[:id])
    end

    def find_list
      @list ||= List.find_by_token(params[:list_id])
    end

    def authorize_list
      authorize @list
    end

end
