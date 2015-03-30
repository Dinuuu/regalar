module MailerHelper
  def donation_email_elements(user, organization, wish_item)
    @user = user
    @organization = organization
    @wish_item = wish_item
  end
end
