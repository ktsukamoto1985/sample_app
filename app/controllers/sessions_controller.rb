class SessionsController < ApplicationController
  # GET /login
  def new
    # x @session = Sesshon.new
    # o scope: :session + url: login_path
    # don't need to add because we don't use Model
  end
  
  # POST /login
  def create
    # ローカル変数で問題ないので@userにはしなくて十分
    user = User.find_by(email: params[:session][:email].downcase) # find_byなのでいなかったらnilが返ってくる
    
    if user && user.authenticate(params[:session][:password]) #ANDなので@userがnilかfalseならもう右はやらない(nilガード)
      # Success
      log_in user # log_inはsessions_helperにある
      redirect_to user
    else
      # Failure
      # alert-danger => 赤色のflash
      # flash.now[:danger] = 'Invalid email/password combination' # これだと次のページに行ってもまだflashが残ってしまう
      flash.now[:danger] = 'Invalid email/password combination'
      # ハッシュのようだけど「メソッド」なので、.nowが使える（.nowは「今を1回目とする」という意味と捉えて良さそう）
      render 'new'
      # redirect_to vs. render
      # flashは次のrequestが来るまで表示する
      # GET /users/1 => show template
      #                 render 'new' はどこかにrequestを送っているわけではない
      #                 helpとかに行って1回目
    end
  end
  
  # DELETE /logout
  def destroy
    log_out
    redirect_to root_url # ログアウトしたらトップページに飛ばす
    # rootの時はなぜかroot_pathよりroot_urlを見ることが多い
  end
  
end
