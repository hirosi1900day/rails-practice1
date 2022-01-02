# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  name                    :string(255)
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  #フォロー関係のリレーション
  has_many :active_relationships, class_name:
  'Relationship',
  foreign_key: 'follower_id',
  dependent: :destroy
  has_many :passive_relationships, class_name:
  'Relationship',
  foreign_key: 'followed_id',
  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :activities, dependent: :destroy
  #chat関連
  has_many :chatroom_users, dependent: :destroy
  has_many :chatrooms, through: :chatroom_users
  has_many :chatroom_message, dependent: :destroy
  
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true

  def own?(object)
    id == object.user_id
  end

  def like(post)
    like_posts.append(post)
  end

  def unlike(post)
   like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end
  #フォロー関係
  def follow(other_user)
    unless self == other_user
      following.append(other_user)
    end
  end

  def unfollow(other_user)
    following.destroy(other_user)
  end

  def followings?(other_user)
    following.include?(other_user)
  end

  def feed 
    Post.where(user_id: following_ids << id)
  end
end
