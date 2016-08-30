class CreateAnagrams < ActiveRecord::Migration
  def up
    create_table :anagrams do |t|
      t.string :key
      t.text :words
    end
  end

  def down
    drop_table :anagrams
  end
end
