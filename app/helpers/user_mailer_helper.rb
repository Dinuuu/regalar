module UserMailerHelper
  private

  def send_creation_mail(wish_item)
    UserMailer.create_donation_email_to_org(current_user,
                                            wish_item.organization, wish_item).deliver
    UserMailer.create_donation_email_to_user(current_user,
                                             wish_item.organization, wish_item).deliver
  end

  def send_cancelation_mail(wish_item, reason)
    UserMailer.cancel_donation_email_to_org(current_user,
                                            wish_item.organization, wish_item, reason).deliver
    UserMailer.cancel_donation_email_to_user(current_user,
                                             wish_item.organization, wish_item, reason).deliver
  end

  def send_cancelation_email
    UserMailer.cancel_gift_request_email_to_org(@gift_request.user,
                                                @gift_request.organization,
                                                @gift_request.gift_item).deliver
  end
end
