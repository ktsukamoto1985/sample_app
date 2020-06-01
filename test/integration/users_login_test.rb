require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty? # flashは特殊な変数、testにも使える（ここではflash消えてないよね？）
    get root_path
    assert flash.empty? # flash消えてるよね？
  end
end
