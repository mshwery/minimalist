class Api::ListsController < Api::BaseController
  respond_to :json

  before_action :authenticate!
  before_action :find_list, only: [:show, :update, :destroy, :leave, :share, :unshare, :contributors]
  before_action :authorize_list, only: [:show, :update, :destroy, :leave, :share, :unshare, :contributors]

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

  def share
    if user_params.has_key?(:email)
      user = User.where(email: user_params[:email]).first_or_create
      if user.join_list(@list)
        head :no_content
      else
        api_error(status: :unprocessable_entity, errors: ['Failed to share list...'])
      end
    else
      api_error(status: :unprocessable_entity, errors: ['Must pass an email address to share this list.'])
    end
  end

  def unshare
    if user_params.has_key?(:email)
      user = @list.users.find_by(email: user_params[:email])
      if user.leave_list(@list)
        head :no_content
      else
        api_error(status: :unprocessable_entity, errors: ['Failed to revoke access for this user.'])
      end
    else
      api_error(status: :unprocessable_entity, errors: ['Must pass an email address to revoke access to this list.'])
    end
  end

  def leave
    if @current_user.leave_list(@list)
      head :no_content
    else
      api_error(status: :unprocessable_entity, errors: ['Failed to leave list'])
    end
  end

  def contributors
    render json: @list.users, list: @list
  end

  private

    def list_params
      params.fetch(:list, {}).permit(:name)
    end

    def user_params
      params.permit(:email)
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
