module Comable
  module RoleOwner
    extend ActiveSupport::Concern

    included do
      extend Enumerize

      enumerize :role, in: %i(
        admin
        reporter
        customer
      ), default: :customer, predicates: true, scope: true
    end
  end
end
