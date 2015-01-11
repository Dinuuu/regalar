class User < ActiveRecord::Base
  extend UserAuthenticationHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities
  has_and_belongs_to_many :organizations
  has_many :comments
  has_many :contributions

  mount_uploader :avatar, AvatarUploader

  def email_required?
    super && (provider.blank? || provider != 'twitter')
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    encrypted_password.blank? ? update_attributes(params, *options) : super
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
