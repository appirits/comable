source "https://rubygems.org"

# Declare your gem's dependencies in comable.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
gem 'coveralls', require: false

group :development, :test do
  gem 'pg'
  gem 'rspec-rails'
  gem 'factory_girl_rails', require: false
  gem 'capybara'
  gem 'rspec-example_steps'
  gem 'rubocop'
  gem 'bullet'
end
