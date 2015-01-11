class PurchasesController < ApplicationController

  class << self
    def callbacks(*types)
      types.each do |action|
        define_method("#{action}_mercadopago_callback") do
          purchase = fetch_purchase
          valid_token = purchase.send("#{action}_token")
          redirect_to :root_path unless valid_token?(params[:security_token], valid_token)
          mercadopago_callback(purchase, action)
        end
      end
    end
  end

  callbacks :success, :pending, :failure

  private

  def mercadopago_callback(purchase, status)
    purchase.update_attributes!(status: status.to_s)
    redirect_to organization_campaign_path(
      purchase.contribution.campaign.organization,
      purchase.contribution.campaign
    )
  end

  def fetch_purchase
    preference = fetch_preference
    Purchase.find(preference['response']['external_reference'])
  end

  def initialize_mercadopago
    MercadoPago.new(
      AppConfiguration.for(:mercadopago).client_id,
      AppConfiguration.for(:mercadopago).client_secret
    )
  end

  def fetch_preference
    mp = initialize_mercadopago
    mp.get_preference(params[:preference_id])
  end

  def valid_token?(token, valid_token)
    token == valid_token
  end
end
