# Comable

[![Build Status](https://secure.travis-ci.org/hyoshida/comable.png)](http://travis-ci.org/hyoshida/comable)
[![Code Climate](https://codeclimate.com/github/hyoshida/comable.png)](https://codeclimate.com/github/hyoshida/comable)
[![Coverage Status](https://coveralls.io/repos/hyoshida/comable/badge.png)](https://coveralls.io/r/hyoshida/comable)
[![Dependency Status](https://gemnasium.com/hyoshida/comable.svg)](https://gemnasium.com/hyoshida/comable)

Comable provides a simple way to add e-commerce features to your Ruby on Rails application.

## Installation

1. Add comable in the `Gemfile`:

  ```ruby
  gem 'comable'
  ```

2. Download and install by running:

  ```bash
  bundle install
  ```

3. Run the generator:

  ```bash
  bundle exec rails generate comable:install
  ```

4. Add routes in the `config/routes.rb`

  ```bash
  Rails.application.routes.draw do
    mount Comable::Core::Engine, at: '/comable'
  end
  ```

## Requirements

* Ruby on Rails 3.2, 4.1, 4.2
* Ruby 2.1, 2.2

And `strong_parameters`, `everywhere` gems are required only for Rails 3.

## Development

To set up a development environment, simply do:

```bash
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake  # run the test suite
```
