# Comable

[![Build Status](https://secure.travis-ci.org/hyoshida/comable.png)](http://travis-ci.org/hyoshida/comable)
[![Code Climate](https://codeclimate.com/github/hyoshida/comable.png)](https://codeclimate.com/github/hyoshida/comable)
[![Coverage Status](https://coveralls.io/repos/hyoshida/comable/badge.png)](https://coveralls.io/r/hyoshida/comable)
[![Dependency Status](https://gemnasium.com/hyoshida/comable.svg)](https://gemnasium.com/hyoshida/comable)

Comable provides a simple way to add e-commerce features to your Ruby on Rails application.

## Installation

1. Add comable in the `Gemfile`:

  ```ruby
  gem 'comable', github: 'hyoshida/comable'
  ```

2. Download and install by running:

  ```bash
  bundle install
  ```

3. Create a file named `comable.rb` in `config/initializers` and add names of tables and columns in this file.

  ```ruby
  Utusemi.configure do
    map :product do
      name :title
    end
  end
  ```

4. Get gem migrations:

  ```bash
  bundle exec rake comable:install:migrations
  ```

## Requirements

* Ruby on Rails 3.2, 4.1
* Ruby 2.1

And `strong_parameters`, `everywhere` gems are required only for Rails 3.

## Development

To set up a development environment, simply do:

```bash
bundle install
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake  # run the test suite
```
