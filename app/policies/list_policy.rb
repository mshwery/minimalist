class ListPolicy < ApplicationPolicy

  def index?
    return true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # @see http://stackoverflow.com/questions/29481726/pundit-scope-in-habtm-rails-relation
      scope.joins(:users).where(lists_users: { user_id: user.id })
    end
  end
end
