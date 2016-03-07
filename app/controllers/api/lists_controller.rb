class Api::ListsController < Api::BaseController
  respond_to :json

  before_action :authenticate!
  before_action :find_list, only: [:show, :update, :destroy, :leave]
  before_action :authorize_list, only: [:show, :update, :destroy, :leave]

  def index
    lists = policy_scope(List)
    render json: lists
  end

  def create
    list = List.new(list_params)
    return api_error(status: 422, errors: list.errors) unless list.valid?

    if list.save
      list.make_owner!(@current_user)
      render json: list
    end
  end

  def show
    render json: @list
  end

  def update
    if @list.update_attributes(list_params)
      render json: @list
    else
      api_error(status: :unprocessable_entity, errors: @list.errors)
    end
  end

  def destroy
    if @list.destroy
      head :no_content
    else
      api_error(status: :unprocessable_entity, errors: @list.errors)
    end
  end

  def leave
    if @current_user.leave_list(@list)
      head :no_content
    else
      api_error(status: :unprocessable_entity, errors: ['Failed to leave list'])
    end
  end

  private

    def list_params
      params.fetch(:list, {}).permit(:name)
    end

    def find_list
      @list ||= List.find_by_token(params[:id])
      # find list within user's list associations
      # @list ||= policy_scope(List).find_by_token(params[:id])
    end

    def authorize_list
      authorize @list
    end

end
