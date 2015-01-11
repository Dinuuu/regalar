# encoding: utf-8
Dir[Rails.root.join("db/helpers/*.rb")].each { |f| require f }

case Rails.env
when "development"
  UsersCreationHelper.create_users
  OrganizationsCreationHelper.create_organizations(5)
  CampaignsCreationHelper.create_campaigns(25)
  AdminUser.create(
   email: 'admin@example.com',
   password: '123123123',
   password_confirmation: '123123123',
  )
when "staging"
  UsersCreationHelper.create_users
  OrganizationsCreationHelper.create_organizations(5)
  CampaignsCreationHelper.create_campaigns(25)
  AdminUser.create(
   email: 'admin@example.com',
   password: '123123123',
   password_confirmation: '123123123',
  )
when "production"
  AdminUser.create(
   email: 'admin@example.com',
   password: '123123123',
   password_confirmation: '123123123',
  )
end
