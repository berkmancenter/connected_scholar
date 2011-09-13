class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, User
    end
  end
end
