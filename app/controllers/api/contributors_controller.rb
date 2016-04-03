class Api::ContributorsController < Api::BaseController
  respond_to :json

  before_action :authenticate!
  before_action :find_list

  def index
    authorize @list, :update?
    render json: @list.users, list: @list
  end

  def create
    authorize @list, :share?
    if user_params.has_key?(:email)
      user = User.where(email: user_params[:email]).first_or_create
      if user.valid? && user.join_list(@list)
        render json: user, list: @list
      else
        api_error(status: :unprocessable_entity, errors: user.errors)
      end
    else
      api_error(status: :unprocessable_entity, errors: ['Must pass an email address to share this list.'])
    end
  end

  def destroy
    authorize @list, :share?
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

  private

    def user_params
      params.permit(:email)
    end

    def find_list
      @list ||= List.find_by_token(params[:list_id])
    end

end
