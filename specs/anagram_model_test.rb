#!/usr/bin/env ruby

require_relative 'spec_helper.rb'

class AnagramModelSpecs < Test::Unit::TestCase

  def teardown
    # delete everything
    a = Anagram.all
    a.destroy_all
  end

  def test_anagram_has_a_key
    anagram = Anagram.create(key: "ader")
    assert_equal(anagram.key, "ader", "An Anagram has a key")
  end

  def test_anagram_has_an_array_of_words
    anagram = Anagram.create(key: "ader", words: nil)
    anagrams_array = ["read", "dear", "dare"]
    anagram.words = anagrams_array
    anagram.save
    assert_equal(anagram.words, anagrams_array)
  end

  def test_anagram_is_invalid_without_a_key
    anagram = Anagram.new(key: nil)
    assert_equal(anagram.save, false)
  end

  def test_anagram_is_still_valid_before_saved_words
    anagram = Anagram.new(key: "ader")
    anagram.save
    assert_equal(anagram.valid?, true)
  end

  def test_anagram_words_are_not_doubled
    anagrams_array = ["read", "dear", "dare"]
  end
end
