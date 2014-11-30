require 'devise'
require 'jquery-rails'
require 'enumerize'
require 'state_machine'

require 'comable/core/configuration'
require 'comable/core/engine'

require 'comable/errors'
require 'comable/cart_owner'
require 'comable/payment_method'

module Comable
  class << self
    def setup(&_)
      yield Comable::Config
    end
  end
end
