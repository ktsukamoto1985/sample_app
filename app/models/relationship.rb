class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  # 規約だと、"modelname_id" => follower_idになってFollowerクラスを探すため、わざわざクラス名を指定する
  
  belongs_to :followed, class_name: "User"
  # 規約だと、"modelname_id" => followed_idになってFollowedクラスを探すため、わざわざクラス名を指定する
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
