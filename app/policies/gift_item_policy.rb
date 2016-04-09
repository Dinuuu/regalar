class GiftItemPolicy < ApplicationPolicy
  def edit?
    user == record.user
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end

  def create?
    !record.eliminated?
  end
end
