class NewContributionContext

  require 'mercadopago.rb'

  attr_reader :redirect_url, :success
  alias_method :success?, :success

  def initialize(contribution, request)
    @contribution = MercadopagoContributionAdapter.new(contribution, request)
    @success = false
    @redirect_url = ''
  end

  def handle
    mp = initialize_mercadopago
    build_purchase
    preference = mp.create_preference(@contribution.mercadopago_data)
    if !preference_error?(preference)
      successful_preference(preference)
    else
      failed_preference
    end
  end

  private

  def initialize_mercadopago
    MercadoPago.new(
      AppConfiguration.for(:mercadopago).client_id,
      AppConfiguration.for(:mercadopago).client_secret
    )
  end

  def preference_error?(preference)
    preference['error'].present?
  end

  def build_purchase
    Purchase.create!(contribution_id: @contribution.id, status: 'awaiting_mp_response')
  end

  def successful_preference(preference)
    @redirect_url = preference['response'][AppConfiguration.for(:mercadopago).init_point]
    @success = true
  end

  def failed_preference
    @success = false
  end
end
