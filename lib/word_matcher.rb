require 'set'

class WordMatcher
  attr_accessor :words,:sorted_by_length
  attr_accessor :min_length
  attr_accessor :all_matched_words_count, :long_word
  
  #add_profiler
  
  def self.load_from_file(filename)
    w = self.new
    File.open(filename).each_line do |line|
      word = line.chomp 
      w.words.add(word)
      # w.min_length = word.length < w.min_length ? word.length : w.min_length
    end
    w.sorted_by_length = w.words.sort{ |w1,w2| w2.length <=> w1.length }
    w.set_min_length
    w
  end
  
  def initialize(word_list  = [])
    self.words = Set.new(word_list)
    self.sorted_by_length = word_list.sort{ |w1,w2| w2.length <=> w1.length }
    self.all_matched_words_count = 0
    self.long_word = nil
    set_min_length
  end
  
  def set_min_length
    word = self.sorted_by_length.last
    if word
      self.min_length = word.length
    else
      self.min_length = Float::INFINITY
    end
  end
  
  def longest_match
    self.long_word
  end  
    
  def find
    word,position = find_longest_match
    if word
      self.long_word = word
      self.all_matched_words_count = 1

      count = count_remaining_matching_words(position)
      
      self.all_matched_words_count  =  self.all_matched_words_count + count
    end    
    self
  end
  
  private
  
  def count_remaining_matching_words(starting_position)
    count = 0
    start_index = starting_position + 1
    end_index = self.sorted_by_length.length
    for i in start_index..end_index do
      word = self.sorted_by_length[i] || ""
      if word.length >= 2*self.min_length
        self.words.delete(word)
        result = find_sub_match(word)        
        count = count + 1 if result
      end
    end
    count
  end
  
  def find_longest_match
    self.sorted_by_length.each_with_index do |word, position|
      #remove the word from set before continuing
      self.words.delete(word)      
      result = find_sub_match(word)
      return [word,position] if result    
    end
    return [nil,-1]
  end
  
  def find_sub_match(word, r = false)
    return true if word.empty?
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

