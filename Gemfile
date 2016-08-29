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

group :development do
  #sqlite makes local development more simple
  gem 'tux'
  gem 'sqlite3'
  gem 'test-unit'
end

group :production do
  #postgres for Heroku deployment
  gem 'pg'
end
