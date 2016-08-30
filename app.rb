require_relative 'config/environment'
require 'sinatra/activerecord'

class App < Sinatra::Base

  before %r{.+\.json$} do
    content_type 'application/json'
  end

  helpers do
    def find_key(word)
      word.split('').sort.join
    end
  end

  get '/' do
    erb :index
  end
end
