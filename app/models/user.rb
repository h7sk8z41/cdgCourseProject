class User < ApplicationRecord
  followability
  has_many :posts
  has_many :comments

  has_and_belongs_to_many :liked_posts, class_name: "Post", join_table: "likes"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable


  validates :username, uniqueness: true

  attr_writer :login

  def login
    @login || self.username || self.email
  end
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
