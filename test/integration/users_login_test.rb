require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # test "login with invalid information" do
  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    # post login_path, params: { session: { email: "", password: "" } }
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty? # flashは特殊な変数、testにも使える（ここではflash消えてないよね？）
    get root_path
    assert flash.empty? # flash消えてるよね？
  end
  
  # test "login with valid information" do
  test "login with valid information followed by logout" do # ログインしてログアウトするように改良する
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user # ちゃんとリダイレクトされようとしてるよね？follow_redirectの前に書く
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # login_pathがないはず
    assert_select "a[href=?]", logout_path # logout_pathがあるはず
    assert_select "a[href=?]", user_path(@user)
    
    # ここからログアウト処理
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
