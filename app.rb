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
    if params[:limit]
      limit = params[:limit].to_i
    end
    key = find_key(word)
    anagram = Anagram.find_by(key: key)
    if anagram
      # set the limit to the params or to the number of words
      limit ||= anagram.words.size
      # don't return the word as its own anagram by subtracting arrays.
      word_as_array = word.split
      anagrams = anagram.words - word_as_array
      {anagrams: anagrams.first(limit)}.to_json
    else
      # if there's no anagram object, return a blank array
      {anagrams: []}.to_json
    end
  end

  # adding words to the datastore
  post '/words:format?' do
    # from SINATRA docs. In case it's being pulled elsewhere too.
    request.body.rewind
    data = JSON.parse request.body.read

    if data['words'].empty?
      status 418
      # a little joke here, albeit short and stout.
    end
    data['words'].each do |word|
      key = find_key(word)
      anagram = Anagram.find_or_create_by(key: key)
      if anagram.words.exclude?(word)
        anagram.words.push(word)
      end
      anagram.save
    end
    status 201
  end

  delete '/words.:format?' do
    anagrams = Anagram.all
    anagrams.destroy_all
    status 204
  end

  delete '/words/:word.:format?' do
    # delete a single word from data store
    word = params[:word]
    key = find_key(word)
    anagram = Anagram.find_by(key: key)
    word_as_array = word.split
    # again, I use the magic of array subtraction
    anagram.words = anagram.words - word_as_array
    anagram.save #update the words array in the database
    {anagrams: anagram.words}.to_json
  end

  ### Optional Features ###

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

  post '/anagrams' do
    request.body.rewind
    data = JSON.parse(request.body.read)
    # checks if a set of words are anagrams of each other
  end

  get '/anagrams/size/:number' do
    # returns all anagrams of size >= X
  end

end
