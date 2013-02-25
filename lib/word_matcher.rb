require 'set'

class WordMatcher
  attr_accessor :words,:sorted_by_length
  attr_accessor :min_length
  attr_accessor :all_matched_words_count, :long_word

  #add_profiler

  def self.load_from_file(filename)
    # w = self.new
    # File.open(filename).each_line do |line|
    #   word = line.chomp
    #   # w.words.add(word)
    #   w.words[word] = true
    #   # w.min_length = word.length < w.min_length ? word.length : w.min_length
    # end
    # w.sorted_by_length = w.words.keys.sort{ |w1,w2| w2.length <=> w1.length }
    # w.set_min_length
    # w
    words = []
    File.open(filename).each_line do |line|
      word = line.chomp
      words << word
      # w.words.add(word)
      # w.words[word] = true
      # w.min_length = word.length < w.min_length ? word.length : w.min_length
    end
    # w.sorted_by_length = w.words.keys.sort{ |w1,w2| w2.length <=> w1.length }
    
    WordMatcher.new(words)    
  end

  def initialize(word_list  = [])
    self.words = Hash[word_list.map{|k| [k, true]}]
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
      self.all_matched_words_count  +=  count
    end
    self
  end

  private

  def count_remaining_matching_words(starting_position)
    count = 0
    start_index = starting_position + 1
    end_index = self.sorted_by_length.length
    i = start_index
    until i > end_index do
      word = self.sorted_by_length[i]
      break if word.nil?
      if word.length >= 2*self.min_length
        self.words.delete(word)
        result = find_sub_match(word)
        count = count + 1 if result
      end
      i += 1
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
    # return false if word.length < self.min_length
    return true if word.empty?
    i = 0
    until i > word.length do
      if(i+1 < self.min_length)
        #skip because there is no point checking this word suffix/prefix as it is smaller than smallest word on the list
        i += 1
        next
      end
      
      match_found =  match(word[0..i])
      remaining_word = word[i+1,word.length]
      if(match_found && find_sub_match(remaining_word, true))
        return true
      end
      i += 1
    end
    return false
  end

  def match(word)
    self.words[word]
    # self.words.member?(word)
  end
end
