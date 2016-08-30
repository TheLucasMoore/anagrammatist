class Anagram < ActiveRecord::Base
  include ActiveModel::Validations
  serialize :words, Array

  attr_accessor :key, :words
  validates_presence_of :key

end
