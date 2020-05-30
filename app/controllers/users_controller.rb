class UsersController < ApplicationController
  
  # GET /users/:id
  def show
    # @user = User.first
    @user = User.find(params[:id])
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users (+ params)
  def create
    # User.create(params[:user])
    @user = User.new(user_params)
    if @user.save
      # Success (valid params)
    else
      # Failure (invalid params)
      render 'new'
    end
  end
  
  private
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end
end
