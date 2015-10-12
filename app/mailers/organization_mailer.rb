class OrganizationMailer < Notifier
  include MailerHelper

  def confirm_donation_email_to_user(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @user.email, subject: I18n.t('mailer.donation.confirmed')
  end

  def create_gift_request_email_to_org(user, organization, gift_item)
    gift_request_email_elements(user, organization, gift_item)
    mail to: @organization.email, subject: I18n.t('mailer.gift_request.created')
  end

  def create_gift_request_email_to_user(user, organization, gift_item)
    gift_request_email_elements(user, organization, gift_item)
    mail to: @user.email, subject: I18n.t('mailer.gift_request.new')
  end

  def cancel_donation_email_to_user(user, organization, wish_item, reason)
    donation_email_elements(user, organization, wish_item, reason)
    mail to: @user.email, subject: I18n.t('mailer.donation.canceled')
  end

  def cancel_gift_request_email_to_org(user, organization, gift_item, reason)
    gift_request_email_elements(user, organization, gift_item, reason)
    mail to: @organization.email, subject: I18n.t('mailer.gift_request.canceled')
  end

  def cancel_gift_request_email_to_user(user, organization, gift_item, reason)
    gift_request_email_elements(user, organization, gift_item, reason)
    mail to: @user.email, subject: I18n.t('mailer.gift_request.canceled')
  end

  def confirm_gift_request_email_to_user(user, organization, gift_item)
    gift_request_email_elements(user, organization, gift_item)
    mail to: @user.email, subject: I18n.t('mailer.gift_request.confirm')
  end
end
