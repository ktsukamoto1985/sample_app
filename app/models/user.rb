class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following,            through:     :active_relationships, 
                                  source:      :followed
  has_many :followers,            through:     :passive_relationships, 
                                  source:      :follower
                                  
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
    # Version 1
    # Micropost.where("user_id = ?", id)
    
    # Version 2
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    
    # Version 3
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                  following_ids: following_ids, user_id: id)
    
    # Version 4
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  
end
