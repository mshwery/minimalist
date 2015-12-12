class ListPolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    true
  end

  def show?
    # *any* user can see *any* list?
    true
    # or only lists shared with them
    # record.shared_with?(user)
  end

  def update?
    record.owned_by?(user) || record.shared_with?(user)
  end

  def destroy?
    record.owned_by?(user)
  end

  def leave?
    record.shared_with?(user) && !record.owned_by?(user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # @see http://stackoverflow.com/questions/29481726/pundit-scope-in-habtm-rails-relation
      scope.joins(:users).where(lists_users: { user_id: user.id })
    end
  end
end
