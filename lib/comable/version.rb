module Comable
  class << self
    def gem_version
      Gem::Version.new VERSION::STRING
    end

    def version
      VERSION::STRING
    end
  end

  module VERSION
    STRING = File.read(File.expand_path('../../../COMABLE_VERSION', __FILE__)).strip
    MAJOR, MINOR, TINY, PRE = Comable.gem_version.segments
  end
end
