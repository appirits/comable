module Comable
  module Decoratable
    def self.included(base)
      # refs: http://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      Dir.glob(Rails.root + "app/decorators/comable/#{base.name.demodulize.underscore}_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
