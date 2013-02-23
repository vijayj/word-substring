require 'set'

class WordMatcher
  attr_accessor :words
  attr_accessor :sorted_by_length
  attr_accessor :all_found_words
  # attr_accessor :longest_word
  
  #add_profiler
  
  def initialize(word_list)
    self.words = Set.new(word_list)
    self.sorted_by_length = word_list.sort{ |w1,w2| w2.length <=> w1.length }
    self.all_found_words = []
  end
  
  def longest_match
    all_found_words.first
  end
  
  def all_found_word_count
    all_found_words.count
  end
  
  def find
    self.sorted_by_length.each_with_index do |word,i|
      #remove the word from set before continuing
      self.words.delete(word)      
      result = find_sub_match(word)
      if(result)
        all_found_words << word
      end
    end
    self
  end
  
  def find_sub_match(word, r = false)
    return true if word.empty?
    #can optimize counter if we know miniumum length
    for i in 0..word.length
      match_found = match(word[0..i])
      remaining_word = word[i+1,word.length]
      if(match_found && find_sub_match(remaining_word, true))
        return true
      end        
    end
    return false 
  end
  
  def match(word)
    self.words.member?(word)
  end
end

