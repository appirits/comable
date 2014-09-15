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

if ENV['COMABLE_NESTED']
  task default: ['app:spec', 'rubocop']
else
  APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
  load 'rails/tasks/engine.rake'

  namespace :app do
    namespace :spec do
      desc 'Run the code examples'
      RSpec::Core::RakeTask.new(:all) do |t|
        t.pattern << ',core/spec/**{,/*/**}/*_spec.rb'
        t.pattern << ',backend/spec/**{,/*/**}/*_spec.rb'
      end

      desc 'Run the code examples in core/spec'
      RSpec::Core::RakeTask.new(:core) do |t|
        t.pattern = '../core/spec/**{,/*/**}/*_spec.rb'
      end

      desc 'Run the code examples in backend/spec'
      RSpec::Core::RakeTask.new(:backend) do |t|
        t.pattern = '../backend/spec/**{,/*/**}/*_spec.rb'
      end
    end
  end

  namespace :db do
    task 'migrate' => 'app:db:migrate'
    task 'app:db:migrate' => 'migrate:all'

    namespace :migrate do
      task :all do
        %w( core backend ).each do |gem_name|
          command = "cd #{gem_name} && test -d db && bundle exec rake db:migrate RAILS_ENV=#{Rails.env} COMABLE_NESTED=true"
          puts command
          system command
        end
      end
    end

    namespace :migrate do
      task 'reset' => 'app:db:migrate:reset'
      task 'app:db:migrate:reset' => 'app:db:migrate'
      task 'app:db:migrate' => 'reset:all'

      namespace :reset do
        task :all do
          %w( core backend ).each do |gem_name|
            command = "cd #{gem_name} && test -d db && bundle exec rake db:migrate:reset RAILS_ENV=#{Rails.env} COMABLE_NESTED=true"
            puts command
            system command
          end
        end
      end
    end
  end

  task default: ['app:spec:all', 'rubocop']
end

Bundler::GemHelper.install_tasks

# from https://github.com/rspec/rspec-rails/issues/936
task 'test:prepare'

task :rubocop do
  exec 'rubocop'
end
