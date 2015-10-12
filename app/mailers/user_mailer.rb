class UserMailer < Notifier
  include MailerHelper

  def create_donation_email_to_org(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @organization.email, subject: I18n.t('mailer.donation.new')
  end

  def create_donation_email_to_user(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @user.email, subject: I18n.t('mailer.donation.thanks')
  end

  def cancel_donation_email_to_org(user, organization, wish_item, reason)
    donation_email_elements(user, organization, wish_item, reason)
    mail to: @organization.email, subject: I18n.t('mailer.donation.canceled')
  end

  def cancel_donation_email_to_user(user, organization, wish_item, reason)
    donation_email_elements(user, organization, wish_item, reason)
    mail to: @user.email, subject: I18n.t('mailer.donation.canceled')
  end

  def cancel_gift_request_email_to_org(user, organization, gift_item)
    gift_request_email_elements(user, organization, gift_item)
    mail to: @organization.email, subject: I18n.t('mailer.gift_request.canceled')
  end
end
