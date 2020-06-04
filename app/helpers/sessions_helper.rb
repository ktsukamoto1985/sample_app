module SessionsHelper
  
  # methodに変換してあげると簡単
  def log_in(user)
    session[:user_id] = user.id
    # サーバへの保存とCookieの保存を両方やっている
  end
  
  def current_user
    
    if session[:user_id] # DBに問い合わせない　この段階でセッションがないならifの中身は実行されない
      # User.find_by(id: session[:user_id]) # DBに問い合わせる
      @current_user ||= User.find_by(id: session[:user_id]) 
      # ↑logged_in?が何度も何度も呼び出されるので、インスタンス変数に保存しておきたい
      # インスタンス変数にさえしておけば1回のrequest中に何度でも呼び出せる
      
      # 要はこういうことがやりたい
      # if @current_user.nil? # @current_userがnilならfind_byする
      #   @current_user = User.find_by(id: session[:user_id]) 
      #   return @current_user
      # else # @current_userがnilじゃないならそのまま返せばいいじゃない
      #   return @current_user
      # end
      # これを1行で書けるようにしたのがコメントアウトしてないコード
      # a ||= hoge -> a = a || hoge (a += 1と同じような書き方)
      # 元のaがtrueならそのまま、falseならhogeをする
      
      # こういうのをメモ化という
      
    end
    
  end
  
  def logged_in?
    !current_user.nil? # current_userが存在していればtrue
  end
  
  # 現在のユーザーをログアウトする
  def log_out # 引数はいらないんだなあ
    session.delete(:user_id) # sessionの値を消す
    @current_user = nil # メモ化した変数を消す
  end
  
end
