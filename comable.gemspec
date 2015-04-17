version = File.read(File.expand_path('../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'
  s.description = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md', 'COMABLE_VERSION']

  s.required_ruby_version = '>= 2.1.5'

  s.add_dependency 'comable_core', version
  s.add_dependency 'comable_frontend', version
  s.add_dependency 'comable_backend', version
end
