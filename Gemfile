# A sample Gemfile
source "https://rubygems.org"

gem 'sinatra'
gem 'thin'
gem 'sinatra-contrib'
gem 'rake'
gem 'activerecord'
gem 'standalone_migrations', '~> 1.0.13'
gem 'omniauth'

group :development do
  gem 'sqlite3'
end

group :test do
  gem 'rspec'
  gem 'rspec-html-matchers'
end

group :production do
  gem 'omniauth-openid'
  gem 'pg'
end
