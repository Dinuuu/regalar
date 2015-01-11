class CampaignPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def update?
    record.organization.users.include?(user)
  end

end
