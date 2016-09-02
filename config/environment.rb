ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require './app'
require_all 'models'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///development')

ActiveRecord::Base.establish_connection(
 :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
 :host     => db.host,
 :username => db.user,
 :password => db.password,
 :database => db.path[1..-1],
 :encoding => 'utf8'
)
