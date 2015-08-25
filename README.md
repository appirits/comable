# Comable

[![Build Status](https://img.shields.io/travis/appirits/comable.svg?style=flat-square)](http://travis-ci.org/appirits/comable)
[![Code Climate](https://img.shields.io/codeclimate/github/appirits/comable.svg?style=flat-square)](https://codeclimate.com/github/appirits/comable)
[![Coverage Status](https://img.shields.io/coveralls/appirits/comable.svg?style=flat-square)](https://coveralls.io/r/appirits/comable)
[![Dependency Status](https://img.shields.io/gemnasium/appirits/comable.svg?style=flat-square)](https://gemnasium.com/appirits/comable)
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

## Access the admin panel

You will need to import the seed data if admin user does not exist.

```bash
bundle exec rake db:seed
```

Go to your browser and open `http://localhost:3000/admin`.

## Requirements

* Ruby on Rails 4.0, 4.1, 4.2
* Ruby 2.1, 2.2

Rails 3 is not supported.

## Development

To set up a development environment, simply do:

```bash
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake  # run the test suite
```
