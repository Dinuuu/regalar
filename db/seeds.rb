# encoding: utf-8
Dir[Rails.root.join("db/helpers/*.rb")].each { |f| require f }

case Rails.env
when "development"
  UsersCreationHelper.create_users
  OrganizationsCreationHelper.create_organizations(5)
  WishItemsCreationHelper.create_wish_items(25)
  DonationsCreationHelper.create_donations
  GiftItemsCreationHelper.create_gift_items(25)
  GiftRequestsCreationHelper.create_gift_requests
  LevelsCreationHelper.create_levels
  AdminUser.create(
   email: 'admin@regalar.com',
   password: '123123123',
   password_confirmation: '123123123',
  )
when "staging"
  LevelsCreationHelper.create_levels
when "production"
  LevelsCreationHelper.create_levels
end
