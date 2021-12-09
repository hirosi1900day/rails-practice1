# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  name             :string(255)
#  salt             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  #フォロー関係のリレーション
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_mamy :followers, through: :reverse_of_relationships, source: :user


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
      followings.append(other_user)
    end
  end

  def unfollow(other_user)
    followings.destroy(other_user)
  end

  def following?(other_user)
    followings.include?(other_user)
  end
end
