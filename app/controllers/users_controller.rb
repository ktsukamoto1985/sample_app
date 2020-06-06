class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  
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
    if @user.save # User.saveに成功した場合はtrueが返ってくる
      # Success (valid params)
      # ユーザー登録と同時にログインもする
      log_in @user
      
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
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id]) # findにしているので、存在しなかった場合例外が発生
    # => app/views/users/edit.html.erb
  end
  
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params) # User.updateに成功した場合はtrueが返ってくる
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # @user.errorsにエラーが入る anyで引っ張ってこれる
      render 'edit'
    end
  end
  
  private
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end
  
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
