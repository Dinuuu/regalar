class UserMailer < Notifier
  include MailerHelper

  def create_donation_email(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @organization.email, subject: 'You have a new donation'
  end

  def cancel_donation_email(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @organization.email, subject: 'The donation was canceled'
  end
end
