require 'ffaker'

require 'comable/core'

require 'comable/sample/engine'
require 'comable/sample/address'
require 'comable/sample/name'
require 'comable/sample/phone_number'

module Comable
  module Sample
    class << self
      def translate(key, options = {})
        Comable.translate("sample.#{key}", options)
      end

      alias_method :t, :translate

      def import_all
        definitions.each do |definition|
          import(definition)
        end
      end

      def import(filename)
        filepath = Rails.root.join("db/samples/#{filename}.rb")
        filepath = "#{default_dir}/#{filename}.rb" unless File.exist?(filepath)
        require File.expand_path(filepath)
      end

      private

      def definitions
        Dir["#{default_dir}/*.rb"].map do |filepath|
          File.basename(filepath, '.rb')
        end.sort
      end

      def default_dir
        "#{File.dirname(__FILE__)}/../../db/samples"
      end
    end
  end
end
