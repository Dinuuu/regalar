class WishItemPolicy < ApplicationPolicy
  def show?
    true
  end

  def index
    show?
  end

  def update?
    user.organizations.include? record.organization
  end

  def edit?
    update?
  end

  def destroy?
    user.organizations.include? record.organization
  end
end
