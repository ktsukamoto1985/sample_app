class UsersController < ApplicationController
  
  def show
    # @user = User.first
    @user = User.find(params[:id])
  end
  
  def new
  end
end
