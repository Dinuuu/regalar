class User < ActiveRecord::Base
  extend UserAuthenticationHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities
  has_and_belongs_to_many :organizations
  has_many :comments
  has_many :donations

  mount_uploader :avatar, ImageUploader

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

  def level
    confirmed_donations = Donation.for_user(self).done.count
    Level.where('levels.from <= ? AND levels.to > ?', confirmed_donations, confirmed_donations)
      .first
  end

  def confirmed_donations
    organizations_id = Donation.for_user(self).done.uniq.pluck(:organization_id)
    donations = []
    organizations_id.each do |org_id|
      donations << concreted_donations_for_organization(org_id)
    end
    donations
  end

  private

  def concreted_donations_for_organization(org_id)
    organization = Organization.find(org_id)
    organization_donations = {}
    organization_donations[:organization] = organization
    organization_donations[:donations] = Donation.for_user(self)
                                         .for_organization(organization).done
    organization_donations
  end
end
