class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  validates :name,  presence: true,
                   length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                   length: { maximum: 255 },
                   format: { with: VALID_EMAIL_REGEX },
                   uniqueness: true
  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }
  
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
  
  
end
