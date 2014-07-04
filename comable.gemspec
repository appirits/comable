$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Testing Against Multiple Rails Versions
# from http://www.schneems.com/post/50991826838/testing-against-multiple-rails-versions/
rails_version = ENV['RAILS_VERSION'] || 'default'
rails_version_spec = (rails_version == 'default') ? '>= 3.2.0' : "~> #{rails_version}"

# Maintain your gem's version:
require 'comable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable'
  s.version     = Comable::VERSION
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'
  s.description = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', rails_version_spec
  s.add_dependency 'slim-rails'
end
