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
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

# from https://github.com/rspec/rspec-rails/issues/936
task 'test:prepare'

task :rubocop do
  exec 'rubocop'
end

namespace :app do
  namespace :spec do
    desc 'Run the code examples'
    RSpec::Core::RakeTask.new(:all) do |t|
      t.pattern << ',backend/spec/**{,/*/**}/*_spec.rb'
    end

    desc 'Run the code examples in backend/spec'
    RSpec::Core::RakeTask.new(:backend) do |t|
      t.pattern = '../backend/spec/**{,/*/**}/*_spec.rb'
    end
  end
end

task default: ['app:spec:all', 'rubocop']
