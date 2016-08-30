class Anagram < ActiveRecord::Base
  include ActiveModel::Validations
  serialize :words, Array
  validates_presence_of :key
  validates_uniqueness_of :key
end
