class ApplicationController < ActionController::Base
  # sessions_controllerもusers_controllerもApplicationControllerを継承しているので、
  # ここに便利メソッドを入れておくと全部の子Controllerにも継承できる
  include SessionsHelper
  
  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
