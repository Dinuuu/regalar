module ProviderToLinkHelper

  def provider?(provider)
    current_user.identities.each do |identity|
      return true if identity.provider == provider
    end
    false
  end

end
