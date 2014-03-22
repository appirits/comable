ENV['DUMMY_APP'] ||= 'dummy'

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Comable'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/#{ENV['DUMMY_APP']}/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new('app:spec:custom') do |spec|
  spec.pattern = [ "spec/{models,views,controllers,helpers,#{ENV['DUMMY_APP']}}/**/*_spec.rb", "spec/*_spec.rb"  ]
end

task default: [ 'app:db:migrate', 'app:spec:custom' ]
