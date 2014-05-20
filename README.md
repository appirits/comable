# Comable

[![Build Status](https://secure.travis-ci.org/hyoshida/comable.png)](http://travis-ci.org/hyoshida/comable)
[![Code Climate](https://codeclimate.com/github/hyoshida/comable.png)](https://codeclimate.com/github/hyoshida/comable)
[![Coverage Status](https://coveralls.io/repos/hyoshida/comable/badge.png)](https://coveralls.io/r/hyoshida/comable)
[![Dependency Status](https://www.versioneye.com/user/projects/531934ceec1375cd39000931/badge.png)](https://www.versioneye.com/user/projects/531934ceec1375cd39000931)

This project rocks and uses MIT-LICENSE.

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
  module Comable
    class Engine < ::Rails::Engine
      config.product_table = :products
      config.product_columns = { name: :title }
      config.customer_table = :customers
      config.stock_table = :stocks
    end
  end
  ```

4. Get gem migrations:

  ```bash
  bundle exec rails generate comable:install
  ```

## Requirements

* Ruby on Rails 3.2, 4.0
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
