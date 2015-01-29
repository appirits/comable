module Comable
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Comable::Customer.new # guest user (not logged in)

      case user.role.to_sym
      when :admin
        can :manage, :all
      when :reporter
        can :read, :all
      end
    end
  end
end
