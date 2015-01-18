require 'devise'
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

    def translate(key, options = {})
      I18n.translate("comable.#{key}", options)
    end

    alias_method :t, :translate
  end
end
