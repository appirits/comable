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

def command(string)
  puts string
  system string
end

if File.exist?('comable.gemspec')
  $LOAD_PATH.unshift File.expand_path('..', __FILE__)
  require 'tasks/release'

  namespace :app do
    namespace :spec do
      desc 'Run the code examples'
      RSpec::Core::RakeTask.new(:all) do |t|
        FRAMEWORKS.each do |framework|
          t.pattern << ",#{framework}/spec/**{,/*/**}/*_spec.rb"
        end
      end

      FRAMEWORKS.each do |framework|
        desc "Run the code examples in #{framework}/spec"
        RSpec::Core::RakeTask.new(framework) do |t|
          t.pattern = "../#{framework}/spec/**{,/*/**}/*_spec.rb"
        end
      end
    end
  end

  namespace :db do
    task 'migrate' => 'app:db:migrate'
    task 'app:db:migrate' => 'migrate:all'

    namespace :migrate do
      task :all do
        FRAMEWORKS.each do |framework|
          command "cd #{framework} && test -d db/migrate && bundle exec rake db:migrate RAILS_ENV=#{Rails.env}"
        end
      end
    end

    namespace :migrate do
      task 'reset' => 'app:db:migrate:reset'
      task 'app:db:migrate:reset' => 'app:db:migrate'
      task 'app:db:migrate' => 'reset:all'

      namespace :reset do
        task :all do
          command "bundle exec rake db:drop db:create RAILS_ENV=#{Rails.env}"
          Rake::Task['db:migrate'].invoke
        end
      end
    end
  end

  task default: ['app:spec:all', 'rubocop', 'brakeman:all']
else
  task default: ['app:spec', 'rubocop', 'brakeman']
end

Bundler::GemHelper.install_tasks

# from https://github.com/rspec/rspec-rails/issues/936
task 'test:prepare'

task :rubocop do
  sh 'rubocop'
end

task :brakeman do
  sh 'brakeman --exit-on-warn --ignore-config .brakeman.ignore'
end

namespace :brakeman do
  task :all do
    FRAMEWORKS.each do |framework|
      sh "brakeman --exit-on-warn --ignore-config .brakeman.ignore #{framework}"
    end
  end
end
