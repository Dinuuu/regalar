class OrganizationPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def update?
    record.users.include?(user)
  end

end
