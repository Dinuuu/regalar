module MailerHelper
  def donation_email_elements(user, organization, wish_item)
    @user = user
    @organization = organization
    @wish_item = wish_item
  end

  def gift_request_email_elements(user, organization, gift_item)
    @user = user
    @organization = organization
    @gift_item = gift_item
  end
end
