# Comable

[![Build Status](https://img.shields.io/travis/hyoshida/comable.svg?style=flat-square)](http://travis-ci.org/hyoshida/comable)
[![Code Climate](https://img.shields.io/codeclimate/github/hyoshida/comable.svg?style=flat-square)](https://codeclimate.com/github/hyoshida/comable)
[![Coverage Status](https://img.shields.io/coveralls/hyoshida/comable.svg?style=flat-square)](https://coveralls.io/r/hyoshida/comable)
[![Dependency Status](https://img.shields.io/gemnasium/hyoshida/comable.svg?style=flat-square)](https://gemnasium.com/hyoshida/comable)
[![Gem Version](https://img.shields.io/gem/v/comable.svg?style=flat-square)](https://rubygems.org/gems/comable)

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

4. Start up your application:

  ```bash
  bundle exec rails server
  ```

  Go to your browser and open `http://localhost:3000`.

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
