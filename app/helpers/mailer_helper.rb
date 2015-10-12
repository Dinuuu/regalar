module MailerHelper
  def donation_email_elements(user, organization, wish_item, reason = nil)
    @user = user
    @organization = organization
    @wish_item = wish_item
    @reason = reason
  end

  def gift_request_email_elements(user, organization, gift_item, reason = nil)
    @user = user
    @organization = organization
    @gift_item = gift_item
    @reason = reason
  end
end
