# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Dummy::Application.config.secret_key_base = 'b845f9a4db33625867659bc0d797b552ef1830986321dcb4e9c1a572965d5e2dfdb7f90be838f2f7b8e113ff7a50dca7993380be09c07b67f8f2490324adeb8a'
Dummy::Application.config.secret_token = Dummy::Application.config.secret_key_base if Rails::VERSION::MAJOR == 3
