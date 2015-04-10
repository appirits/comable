module Comable
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Comable::User.new # guest user (not logged in)

      case user.role.to_sym
      when :admin
        can :manage, :all
      when :reporter
        can :read, :all
      else
        fail CanCan::AccessDenied
      end
    end
  end
end
