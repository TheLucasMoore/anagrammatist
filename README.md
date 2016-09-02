# Anagrammatist

An anagrammatist is someone who create anagrams. This is the API for aspiring annagrammatists.

# Implementation details

The goal for this API is to return anagrams for any word as quickly as possible.
The data store of this API digests a text file of every word in the English language (or at least the 235,886 most frequently used words).
Then the results of anagrams for any word are instantly available.

This API is built in Ruby, utilizing Sinatra to render JSON data at each end point. [The deployed app](https://anagrammatist.herokuapp.com/) has a front end built with Angular, for instant search of the whole database.

# Design overview and trade-offs considered

I am always intentional with the things I design, sketching out the overarching structure on paper before digging into the build. Here's a few things I considered and the final decisions I made.

## Sinatra vs. Rails

The decision to use Sinatra instead of Rails here was purposeful. Rails is a fully featured MVC framework. I do love to build things with Rails, but it seemed like overkill to simply run one model, one controller and one view. Additionally, while some of the magic of Rails can be nice, I wanted to build the environment, tests and database configuration entirely on my own. I'm hungry to learn and I seek out challenges.

One example of such a challenge came with an app crash at deployment. I learned that I needed to manually export the $RACK_ENV variable to Heroku in my Procfile for this web application to function. The Rails apps I've deployed in the past seemed to handle this easily, but I enjoy developing as deeply as possible. In this case, I got to build out the Rack Middleware environments for testing, development and deployment entirely by myself. (along with Stackoverflow, of course)

## ActiveRecord vs. Redis

My first instinct with the need for a fast API was to create a datastore in Redis. While this would be fast, having 200,000+ words loaded into memory had a bit of a funky code smell to it. I tried it and did not like it.

The one advantage of this decision remained however. The delete end point would simply be clearing the cache from memory (`redis.flushall`) instead of destroying the contents of the database. In production, with so many words in the database, re-seeding it will take quite a while.

When considering the end user's story for interacting with this API, they simply want instant results. Using ActiveRecord to store the Anagram model, as well as the ability to seed the database with the contents of the entire dictionary, has meant that the queries to the API are essentially instant. [You can see that here.](https://anagrammatist.herokuapp.com/)

## Data Structure

Each anagram is found by it's key, which is the word split into letters, sorted and joined back together. Words with the same key are stored in an array called 'words' in the Anagram class. This process of finding the key for a word is done in the controller with a helper:

``` ruby
def find_key(word)
  word.split('').sort.join
end

find_key("read")
#=> "ader"

anagram = Anagram.find_by(key: "ader")
anagram.key = "ader"
anagram.words = ["ared","read","dare","dear"]
```

# Creating this in your local environment

To begin to develop with this API in your local environment, first, email me so I can add you to the private github repo. Then fork/clone this repo. If you're working out the zip file, well, perfect. We're ready to get started.

## Set Up, Testing

1. Run `bundle` to install the dependencies
2. `rake db:create`, `rake db:migrate` and (optionally) `rake db:seed`. Note that seeding 200,000+ words take a very long time. It's intentionally designed to run in production, which took place in the background. The tests of the API functionality will work with or without the seeding.
3. `thin start` will serve up the API and front end at `localhost:3000`. The server must be running for the tests to pass.
4. `ruby run_tests.rb` during development to ensure you haven't broken the core functionality or model validations.

# Interacting with the Local API

These commands will show you how the API works locally.

```{bash}
# Adding words to the corpus
$ curl -i -X POST -d '{ "words": ["read", "dear", "dare"] }' http://localhost:3000/words.json
HTTP/1.1 201 Created
...

# Checking if a set of words are anagrams
$ curl -i -X POST -d '{ "words": ["read", "dear", "dare"] }' http://localhost:3000/anagrams.json
HTTP/1.1 201 Created
...
{
  anagrams?: true
}

# ... or if a set of words are NOT anagrams at the same end point
$ curl -i -X POST -d '{ "words": ["cool", "stuff", "huh?"] }' http://localhost:3000/anagrams.json
HTTP/1.1 201 Created
...
{
  anagrams?: false
}

# Fetching anagrams
$ curl -i http://localhost:3000/anagrams/read.json
HTTP/1.1 200 OK
...
{
  anagrams: [
    "dear",
    "dare"
  ]
}

# Specifying maximum number of anagrams
$ curl -i http://localhost:3000/anagrams/read.json?limit=1
HTTP/1.1 200 OK
...
{
  anagrams: [
    "dare"
  ]
}

# Delete single word
$ curl -i -X DELETE http://localhost:3000/words/read.json
HTTP/1.1 200 OK
...

# Delete all words
$ curl -i -X DELETE http://localhost:3000/words.json
HTTP/1.1 204 No Content
...

# Delete a word and all it's anagrams
$ curl -i -X DELETE http://localhost:3000/anagrams/read.json
HTTP/1.1 200 OK
...
```

# Interacting with the Live API

While the live API page currently has the anagram search function enabled, the entire API is actually live and working.

To see this API running, simply change `http://localhost:3000` to `https://anagrammatist.herokuapp.com`. Note that it's running on hobby-dev Heroku, so there's going to be room for improvement in performance. Those dynamos get sleepy after a while.

For one example, to grab the anagrams for any word:

```bash
curl -i https://anagrammatist.herokuapp.com//anagrams/read.json
```

Note, the DELETE ALL end point has been disabled in production. Sure, we could build out an authorization scheme with JWTs to ensure only admins can use it, or utilize the famously heavy Devise gem. Or perhaps CanCanCan for permissions. But let's keep it simple, alright? Nobody can delete the data store if the end point is gone.

# Features to add to the API

One bonus feature I did add was an anagram checker. Any set of words posted will return `true` or `false`, depending on whether the words are anagrams of each other.

The other feature I added is to delete a word AND all of it's anagrams.

Additional features that would be interesting to add are end points to return data, like maximum/minimum/average number of anagrams in the database. This can be done with custom Postgres queries or using ActiveRecord's `Anagram.find_by_sql("SELECT ... yadayadayada")` ability.

I'd love to implement anagrams with multiple words or entire sentences.
Things like `no more stars` and `astronomers`, `a perfectionist` and `I often practice` or, my favorite, `Election results` and	`Lies – let's recount`. That's getting into AI territory I think though.

## Uses? Scrabble!

The live search functionality here does not discriminate on whether the text entered is a word or not. It searches by the key, so this app is a perfectly useful scrabble word solver. Enter some (or all) of the letters on your board and you're <s>cheating</s> winning in no time!

![anagrams and scrabble](http://pad1.whstatic.com/images/thumb/e/e1/Manage-a-Rack-in-Scrabble-Step-3-Version-2.jpg/aid1916432-728px-Manage-a-Rack-in-Scrabble-Step-3-Version-2.jpg)

"What? Oh no, I'm just texting someone. I'm not cheating at family scrabble on my phone with a web application I built." -me, probably soon.
