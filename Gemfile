source "https://rubygems.org"

# application gems
gem "sinatra"
gem "redis"
gem 'json'
gem 'require_all'

# shotgun server
gem 'shotgun'

# databse gems
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'

group :test do
  #sqlite makes local development more simple
  gem 'sqlite3'
end

group :development, :production do
  #postgres for Heroku deployment
  gem 'pg'
  gem 'tux'
  gem 'test-unit'
  gem 'pry'
end
