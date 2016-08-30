require_relative '../config/environment'

IO.foreach('./specs/dictionary.txt') do |line|
  word = line.strip
  key = word.split('').sort.join
  anagram = Anagram.find_or_create_by(key: key)
  # if the word is already in the array, don't add it again
  if !anagram.words.include?(word)
      anagram.words.push(word)
  end
  anagram.save
end
