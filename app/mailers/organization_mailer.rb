class OrganizationMailer < Notifier
  include MailerHelper

  def confirm_donation_email_to_user(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @user.email, subject: 'Your donation was confirmed'
  end

  def cancel_donation_email_to_user(user, organization, wish_item)
    donation_email_elements(user, organization, wish_item)
    mail to: @user.email, subject: 'Your donation was canceled'
  end
end
