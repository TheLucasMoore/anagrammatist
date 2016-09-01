#!/usr/bin/env ruby

require_relative 'spec_helper.rb'
# capture ARGV before TestUnit Autorunner clobbers it

class TestCases < Test::Unit::TestCase

  # runs before each test
  def setup
    @client = AnagramClient.new(ARGV)

    # add words to the dictionary
    @client.post('/words.json', nil, {"words" => ["read", "dear", "dare"] }) rescue nil
  end

  # runs after each test
  def teardown
    # delete everything
    @client.delete('/words.json') rescue nil
  end

  def test_adding_words
    res = @client.post('/words.json', nil, {"words" => ["read", "dear", "dare"] })

    assert_equal('201', res.code, "Unexpected response code")

    # I modified this test to double check the POST persistence before deletion in teardown
    saved = @client.get('/anagrams/read.json')
    body = JSON.parse(saved.body)
    expected_anagrams = %w(dare dear)
    assert_equal(expected_anagrams, body['anagrams'].sort)
  end

  def test_fetching_anagrams

    # fetch anagrams
    res = @client.get('/anagrams/read.json')

    assert_equal('200', res.code, "Unexpected response code")
    assert_not_nil(res.body)

    body = JSON.parse(res.body)

    assert_not_nil(body['anagrams'])

    expected_anagrams = %w(dare dear)
    assert_equal(expected_anagrams, body['anagrams'].sort)
  end

  def test_fetching_anagrams_with_limit

    # fetch anagrams with limit
    res = @client.get('/anagrams/read.json', 'limit=1')

    assert_equal('200', res.code, "Unexpected response code")

    body = JSON.parse(res.body)

    assert_equal(1, body['anagrams'].size)
  end

  def test_fetch_for_word_with_no_anagrams
    # fetch anagrams with limit
    res = @client.get('/anagrams/zyxwv.json')

    assert_equal('200', res.code, "Unexpected response code")

    body = JSON.parse(res.body)

    assert_equal(0, body['anagrams'].size)
  end

  def test_deleting_all_words
    res = @client.delete('/words.json')

    assert_equal('204', res.code, "Unexpected response code")

    # should fetch an empty body
    res = @client.get('/anagrams/read.json')

    assert_equal('200', res.code, "Unexpected response code")

    body = JSON.parse(res.body)

    assert_equal(0, body['anagrams'].size)
  end

  def test_deleting_all_words_multiple_times
    3.times do
      res = @client.delete('/words.json')

      assert_equal('204', res.code, "Unexpected response code")
    end

    # should fetch an empty body
    res = @client.get('/anagrams/read.json', 'limit=1')

    assert_equal('200', res.code, "Unexpected response code")

    body = JSON.parse(res.body)

    assert_equal(0, body['anagrams'].size)
  end

  def test_deleting_single_word
    # delete the word
    res = @client.delete('/words/dear.json')

    assert_equal('200', res.code, "Unexpected response code")

    # expect it not to show up in results
    res = @client.get('/anagrams/read.json')

    assert_equal('200', res.code, "Unexpected response code")

    body = JSON.parse(res.body)

    assert_equal(['dare'], body['anagrams'])
  end

  ### OPTIONAL FEATURE TESTS ###

  def test_deleting_a_word_and_all_its_anagrams
    res = @client.delete('/anagrams/read.json')
    assert_equal('204, res.code')

    deleted = @client.get('/anagrams/read.json')
    assert_equal('200', res.code, "Unexpected response code")
    body = JSON.parse(deleted.body)
    assert_equal(0, body['anagrams'].size)
  end

  def test_route_to_return_word_with_the_most_anagrams
    # post a bunch more anagrams
    @client.post('/words.json', nil, {"words" => ["alerted", "altered", "related", "treadle"] })
    @client.post('/words.json', nil, {"words" => ["carets", "caters", "caster", "crates", "reacts", "recast", "traces"] })

    res = @client.get('/anagrams/data/max.json')
    assert_equal('200', res.code, "Unexpected response code")
    body = JSON.parse(res.body)
    assert_equal(6, body['anagrams'].size)
  end

  def test_posting_if_words_are_anagrams_of_each_other
    # expect a posted set of anagrams to return true
    anagrams = @client.post('/anagrams.json', nil, {"words" => ["read", "dear", "dare"] }) rescue nil
    assert_equal('200', anagrams.code, "Unexpected response code")
    body = JSON.parse(anagrams.body)
    assert_equal(true, body['anagrams?'])

    not_anagrams @client.post('/anagrams.json', nil, {"words" => ["hire", "me", "it", "will", "be", "the", "best", "investment"] }) rescue nil
    # return false
    assert_equal('200', not_anagrams.code, "Unexpected response code")
    body = JSON.parse(not_anagrams.body)
    assert_equal(false, body['anagrams?'])
  end

  def test_anagram_sizes
    # post other size anagrams too. Read has 3 anagram groups, so its size is 3.
    @client.post('/words.json', nil, {"words" => ["alerted", "altered", "related", "treadle"] }) # 4 in group
    @client.post('/words.json', nil, {"words" => ["carets", "caters", "caster", "crates", "reacts", "recast", "traces"] }) #7 in group

    res_three = @client.get('/anagrams/size/3')
    body_of_three = JSON.parse(res_three.body)
    assert_equal(3, body_of_three['anagrams']) # all three are greater than 3

    res_four = @client.get('/anagrams/size/4')
    body_of_four = JSON.parse(res_four.body)
    assert_equal(2, body_of_four['anagrams']) # two anagram sets are greater than 4

    res_seven = @client.get('/anagrams/size/7')
    body_of_seven = JSON.parse(res_seven.body)
    assert_equal(1, body_of_seven['anagrams']) # only one is greater than or equal to 7
  end

  def test_show_database_information_like_min_max_mean
    res = @client.get('/words/data.json')
    assert_equal('200', res.code, "Unexpected response code")
    # stubbed out data will come soon
  end

end
