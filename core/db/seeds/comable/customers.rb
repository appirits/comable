require 'highline/import'

def default_email
  'comable@example.com'
end

def default_password
  'password'
end

def ask_admin_email
  if ENV['ADMIN_EMAIL']
    ENV['ADMIN_EMAIL']
  else
    ask("Email [#{default_email}]: ") do |q|
      q.echo = true
      q.whitespace = :strip
    end
  end.presence || default_email
end

def ask_admin_password
  if ENV['ADMIN_PASSWORD']
    ENV['ADMIN_PASSWORD']
  else
    ask("Password [#{default_password}]: ") do |q|
      q.echo = false
      q.whitespace = :strip
    end
  end.presence || default_password
end

def create_admin_user
  email = ask_admin_email
  password = ask_admin_password

  if Comable::Customer.where(email: email).exists?
    puts "WARNING: The email address has already existed: #{email}"
  else
    Comable::Customer.new do |obj|
      obj.email = email
      obj.password = password
    end.save!
  end
end

if Comable::Customer.with_role(:admin).exists?
  puts 'Admin user has already been previously created.'
else
  create_admin_user
end
