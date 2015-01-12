require 'devise'
require 'jquery-rails'
require 'enumerize'
require 'state_machine'
require 'ancestry'
require 'carrierwave'

require 'comable/core/configuration'
require 'comable/core/engine'

require 'comable/errors'
require 'comable/payment_provider'
require 'comable/state_machine_patch'

module Comable
  class << self
    def setup(&_)
      yield Comable::Config
    end
  end
end
