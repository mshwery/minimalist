class Api::ListsController < Api::BaseController
  respond_to :json

  before_action :authenticate!, only: [:show, :update, :destroy]
  before_action :find_list, only: [:show, :update, :destroy]

  def index
    lists = @user.lists
    render json: lists
  end

  def create
    list = @user.create(list_params)
  end

  def show
    list = List.find_by_token(params[:id])
    render json: list
  end

  private

  def list_params
    # dont `require(:list)` because we want to accept empty bodies on /create for now
    params.permit(:name)
  end

  def find_list
    @list ||= @user.lists.find_by_token(params[:id])
  end

  # def create
  #   list = lists_scope.new(list_params)

  #   if list.save
  #     render json: list, status: :created
  #   else
  #     render json: list.errors, status: :unprocessable_entity
  #   end
  # end
  
  # def update
  #   if list.update_attributes(list_params)
  #     #override the default respond_with behavoir to always send back the model with update
  #     render json: list
  #   else
  #     render json: list.errors, status: :unprocessable_entity
  #   end
  # end
  
  # def destroy
  #   if list.destroy
  #     head :no_content
  #   else
  #     render json: list.errors, status: :unprocessable_entity
  #   end
  # end
end
