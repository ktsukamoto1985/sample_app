require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael) # fixtureから引っ張ってくる
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit' # ちゃんと失敗して元のtemplateに戻ってくる
    assert_select "div.alert", "The form contains 4 errors."
  end
  
  # test "successful edit" do # 今までのテストは
  #   log_in_as(@user) # ログインして
  #   get edit_user_path(@user) # editに飛んで
  #   assert_template 'users/edit' # ちゃんと飛んだね
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user) # editに飛んで（ログインにリダイレクトされる）
    log_in_as(@user) # ログインして
    assert_redirected_to edit_user_url(@user) # editページにちゃんとリダイレクトされたね（フレンドリー）
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
end