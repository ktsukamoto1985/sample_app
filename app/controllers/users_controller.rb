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
    # User.create(params[:user]) とすればいい時代もあったが、
    # 意図せずデータベースを書き換えられる危険性（マスアサインメント脆弱性）のためそれは過去の話
    @user = User.new(user_params)
    if @user.save
      # Success (valid params)
      
      # flash (before GET request)
      flash[:success] = "Welcome to the Sample App!"
      
      # GET "/users/#{@user.id}"
      redirect_to @user
      # redirect to user_path(@user)
      # redirect to user_path(@user.id)
      # redirect to user_path(1)
      #             => /users/1
      
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
