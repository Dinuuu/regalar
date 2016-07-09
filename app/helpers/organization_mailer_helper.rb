module OrganizationMailerHelper
  private

  def send_creation_mail
    OrganizationMailer.create_gift_request_email_to_org(@gift_request.user,
                                                        @gift_request.organization,
                                                        @gift_request.gift_item).deliver
    OrganizationMailer.create_gift_request_email_to_user(@gift_request.user,
                                                         @gift_request.organization,
                                                         @gift_request.gift_item).deliver
  end

  def send_cancelation_mail
    OrganizationMailer.cancel_gift_request_email_to_org(@gift_request.user,
                                                        @gift_request.organization,
                                                        @gift_request.gift_item,
                                                        params[:donation][:reason]).deliver
    OrganizationMailer.cancel_gift_request_email_to_user(@gift_request.user,
                                                         @gift_request.organization,
                                                         @gift_request.gift_item,
                                                         params[:donation][:reason]).deliver
  end

  def send_confirmation_mail
    OrganizationMailer.confirm_gift_request_email_to_user(@gift_request.user,
                                                          @gift_request.organization,
                                                          @gift_request.gift_item).deliver
  end

  def send_confirmation_email(donation)
    OrganizationMailer.confirm_donation_email_to_user(donation.user,
                                                      donation.organization,
                                                      donation.wish_item).deliver
  end

  def send_cancelation_email(donation, reason)
    OrganizationMailer.cancel_donation_email_to_user(donation.user,
                                                     donation.organization,
                                                     donation.wish_item, reason).deliver
  end
end
