# The Project

---

The project is to build an API that allows fast searches for [anagrams](https://en.wikipedia.org/wiki/Anagram). `dictionary.txt` is a text file containing every word in the English dictionary. Ingesting the file doesn’t need to be fast, and you can store as much data in memory as you like.

The API you design should respond on the following endpoints as specified.

- `POST /words.json`: Takes a JSON array of English-language words and adds them to the corpus (data store).
- `GET /anagrams/:word.json`:
  - Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
  - This endpoint should support an optional query param that indicates the maximum number of results to return.
- `DELETE /words/:word.json`: Deletes a single word from the data store.
- `DELETE /words.json`: Deletes all contents of the data store.


**Optional**
- Endpoint that returns a count of words in the corpus and min/max/median/average word length
- Respect a query param for whether or not to include proper nouns in the list of anagrams
- Endpoint that identifies words with the most anagrams
- Endpoint that takes a set of words and returns whether or not they are all anagrams of each other
- Endpoint to return all anagram groups of size >= *x*
- Endpoint to delete a word *and all of its anagrams*

Clients will interact with the API over HTTP, and all data sent and received is expected to be in JSON format

Example (assuming the API is being served on localhost port 3000):

```{bash}
# Adding words to the corpus
$ curl -i -X POST -d '{ "words": ["read", "dear", "dare"] }' http://localhost:3000/words.json
HTTP/1.1 201 Created
...

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
```

Note that a word is not considered to be its own anagram.


## Tests

We have provided a suite of tests to help as you develop the API. To run the tests you must have Ruby installed ([docs](https://www.ruby-lang.org/en/documentation/installation/)):

```{bash}
ruby anagram_test.rb
```

Only the first test will be executed, all the others have been made pending using the `pend` method. Delete or comment out the next `pend` as you get each test passing.

If you are running your server somewhere other than localhost port 3000, you can configure the test runner with configuration options described by

```{bash}
ruby anagram_test.rb -h
```

You are welcome to add additional test cases if that helps with your development process. The [benchmark-bigo](https://github.com/davy/benchmark-bigo) gem is helpful if you wish to do performance testing on your implementation.

## API Client

We have provided an API client in `anagram_client.rb`. This is used in the test suite, and can also be used in development.

To run the client in the Ruby console, use `irb`:

```{ruby}
$ irb
> require_relative 'anagram_client'
> client = AnagramClient.new
> client.post('/words.json', nil, { 'words' => ['read', 'dear', 'dare']})
> client.get('/anagrams/read.json')
```

## Documentation

Optionally, you can provide documentation that is useful to consumers and/or maintainers of the API.

Suggestions for documentation topics include:

- Features you think would be useful to add to the API
- Implementation details (which data store you used, etc.)
- Limits on the length of words that can be stored or limits on the number of results that will be returned
- Any edge cases you find while working on the project
- Design overview and trade-offs you considered


# Deliverable
---

Please provide the code for the assignment either in a private repository (GitHub or Bitbucket) or as a zip file. If you have a deliverable that is deployed on the web please provide a link, otherwise give us instructions for running it locally.
