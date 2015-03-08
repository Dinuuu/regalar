class MercadopagoContributionAdapter < SimpleDelegator
  include Rails.application.routes.url_helpers

  class << self
    def callbacks(*types)
      types.each do |action|
        define_method("#{action}_mercadopago_callback") do
          token = build_token(action, purchase.id)
          purchase.update_attributes!("#{action}_token" => token)
          mercadopago_callback('purchases', "#{action}_mercadopago_callback", token)
        end
      end
    end
  end

  callbacks :success, :failure, :pending

  def initialize(contribution, request)
    super(contribution)
    @request = request
  end

  def mercadopago_data
    { external_reference: purchase.id,
      items:  items,
      auto_return: 'approved',
      payer: user,
      back_urls: { pending: pending_mercadopago_callback,
                   success: success_mercadopago_callback,
                   failure: failure_mercadopago_callback
                  }
    }
  end

  def items
    [
      { id: '',
        title: 'Regalar',
        quantity: 1,
        unit_price: amount,
        currency_id: 'ARS'
      }
    ]
  end

  private

  def build_token(text, id)
    Digest::SHA2.hexdigest([text, id, Time.current, SecureRandom.hex].join)
  end

  def mercadopago_callback(controller_name, method_name, security_token)
    url_for(
      controller: controller_name,
      action: method_name,
      only_path: false,
      host: @request.host,
      port: @request.port,
      security_token: security_token
    )
  end
end
