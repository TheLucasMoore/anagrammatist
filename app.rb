require_relative 'config/environment'

class App < Sinatra::Base

  before %r{.+\.json$} do
    content_type 'application/json'
  end

  helpers do
    def find_key(word)
      word.split('').sort.join
    end
  end

  # just mocked up here for now.
  get '/' do
    erb :index
  end

  # return anagrams for any word
  get '/anagrams/:word.:format?' do
    word = params[:word]
    key = find_key(word)
    anagram = Anagram.find_by(key: key)
    limit = params[:limit] || anagram.words.size
    # set the limit to the parms or to the number of words
    anagram ? anagrams = anagram.words.first(limit.to_i) - %w(word) : nil
    # don't return the word as its own anagram by subtracting arrays. Handle unfound Anagrams too.
    {anagrams: anagrams}.to_json
  end

  # adding words to the datastore
  post '/words:format?' do

    request.body.rewind
    data = JSON.parse(request.body.read)

    data['words'].each do |word|
      key = find_key(word)
      anagram = Anagram.find_or_create_by(key: key)
      anagram.words.include?("word") ? anagram : anagram.words.push(word)
      # return anagram.words - %w(word)
      status 201
    end
  end

  delete '/words/:word.:format?' do
    # delete a single word from data store
  end

  delete '/words.:format?' do
    # clears the datastore
  end

  # Optional Stuff

  delete '/anagrams/:word.:format?' do
    # deletes a word and all of it's anagrams
  end


  get '/words/data.:format?' do
    # returns JSON of the following:
    #   1. Number of words in DB
    #   2. Min/Max/Median/Average word length
  end

  get '/anagrams/max.:format?' do
    # returns the word with the most anagrams
  end

  post '/anagrams/test' do
    request.body.rewind
    data = JSON.parse(request.body.read)
    # checks if a set of words are anagrams of each other
  end

  get '/anagrams/size/:number' do
    # returns all anagrams of size >= X
  end

end
