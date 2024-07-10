class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

#GET /users
def create
  @user = User.new(user_params)
  if @user.save
    render json: @user, status: :created
  else
    render json: @user.errors, status: :unprocessable_entity
  end
end

  #GET /users/filter
  def filter
       campaign_names = params[:campaign_names]  # Ensure names are stripped of whitespace

       json_conditions = campaign_names.map do |name|
        { "campaign_name": name }
      end

      json_array_string = json_conditions.to_json

      
      @users = User.where("JSON_CONTAINS(campaigns_list, ?)", json_array_string)

      render json: @users
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, campaigns_list: [:campaign_name, :campaign_id])
    end
  end
