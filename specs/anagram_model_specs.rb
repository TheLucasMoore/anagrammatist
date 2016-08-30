require_relative '../config/environment'
require 'test/unit'

class AnagramModelSpecs < Test::Unit::TestCase

  def test_anagram_has_a_key
    anagram = Anagram.create(key: "ader")
    assert_equal(anagram.key, "ader")
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
end
