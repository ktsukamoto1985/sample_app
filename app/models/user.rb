class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  before_save { self.email = self.email.downcase } # saveが実行される直前でこれを実行する
  validates :name,  presence: true,
                   length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                   length: { maximum: 255 },
                   format: { with: VALID_EMAIL_REGEX },
                   uniqueness: true
  has_secure_password
  
  validates :password, presence: true, 
                       length: { minimum: 6 }, 
                       allow_nil: true
  
  # 引数に渡された文字列をハッシュ化して返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # 上は三項演算子　min_cost?がtrueなら開発環境やテスト環境なので頑張らない、falseなら本番なので頑張る
    BCrypt::Password.create(string, cost: cost)
  end
  # ここで def digestとやるとインスタンスメソッドになるが、
  # そうするとfixtureがわざわざインスタンス作ってやらないといけない
  # User.new.digest('foobar')
  # みたいになる
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    Micropost.where("user_id = ?", id)
  end

  
end
