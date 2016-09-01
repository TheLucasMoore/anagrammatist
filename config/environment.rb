ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require './app'
require_all 'models'

configure :development, :test do
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/#{ENV['RACK_ENV']}.sqlite"
  )
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'])

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end
