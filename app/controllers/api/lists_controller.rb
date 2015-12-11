class Api::ListsController < Api::BaseController
  respond_to :json

  before_action :authenticate!
  before_action :find_list, only: [:show, :update, :destroy]

  def index
    @lists = policy_scope(List)
    render json: @lists
  end

  def create
    list = List.new(list_params)
    return api_error(status: 422, errors: list.errors) unless list.valid?

    if list.save
      @current_user.lists << list
      render json: list
    end
  end

  def show
    list = List.find_by_token(params[:id])
    render json: list
  end

  private

  def list_params
    params.fetch(:list, {}).permit(:name)
  end

  def find_list
    @list ||= policy_scope(List).find_by_token(params[:id])
  end

end
