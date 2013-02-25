	# require 'set'
import sys
	
class WordMatcher(object):
	# attr_accessor :words,:sorted_by_length
	# 	attr_accessor :min_length
	# 	attr_accessor :all_matched_words_count, :long_word
	# 	
	#add_profiler
	@staticmethod
	def load_from_file(filename):
		# w = self.new
		# File.open(filename).each_line do |line|
		# word = line.chomp
		# # w.words.add(word)
		# w.words[word] = True
		# # w.min_length = word.length < w.min_length ? word.length : w.min_length
		# end
		# w.sorted_by_length = w.words.keys.sort{ |w1,w2| w2.length <=> w1.length }
		# w.set_min_length
		# w
		words = []
		with open(filename, 'r') as f:
			word_str = f.read()
		words = word_str.split()
		
		# File.open(filename).each_line do |line|
		# word = line.chomp
		# words << word
		# w.words.add(word)
		# w.words[word] = True
		# w.min_length = word.length < w.min_length ? word.length : w.min_length

	# w.sorted_by_length = w.words.keys.sort{ |w1,w2| w2.length <=> w1.length }
	
		return WordMatcher(words)

	
	def __init__(self,word_list = []):
		self.words = set(word_list)
		self.sorted_by_length = word_list
		self.sorted_by_length.sort(key=len)
		self.sorted_by_length.reverse()
		# print "length of sorted word " + str(len(self.sorted_by_length))
		self.all_matched_words_count = 0
		self.long_word = None
		self.min_length = sys.maxint
		self.calc_min_length()

	
	def calc_min_length(self):
		word = self.sorted_by_length[-1]
		# print "word is " + word
		if word:
			self.min_length = len(word)


	
	def longest_match(self):
		return self.long_word

	
	def find(self):
		word,position = self.find_longest_match()
		if word:
			self.long_word = word
			self.all_matched_words_count = 1
			
			count = self.count_remaining_matching_words(position)
			self.all_matched_words_count += count
	
		return self

	
	# private
	
	def count_remaining_matching_words(self,starting_position):
		count = 0
		start_index = starting_position + 1
		for i in range(start_index, len(self.sorted_by_length)):
		# start_index = starting_position + 1
		# i = start_index
		# until i > end_index do:
			word = self.sorted_by_length[i]
			if word == None: break
			if len(word) >= 2*self.min_length:
				self.words.discard(word)
				result = self.find_sub_match(word)
				if result: count = count + 1 

			# i += 1

		return count

	
	def find_longest_match(self):
		for position, word in enumerate(self.sorted_by_length):
		# self.sorted_by_length.each_with_index do |word, position|
		#remove the word from set before continuing
			self.words.discard(word)
			result = self.find_sub_match(word)
			if result: return word,position

		return None,-1

	
	def find_sub_match(self,word, r = False):
		# if r: print "recurse..."
		# return False if word.length < self.min_length
		if word == "": return True
		# return True if word.empty?
		i = 0
		while i <= len(word):
			# if(i+1 < self.min_length):
			# 				#skip because there is no point checking this word suffix/prefix as it is smaller than smallest word on the list
			# 				i += 1
			# 			continue
			
			
			match_found = self.match(word[0:i])
			remaining_word = word[i:]
			# print "match word is " + word[0:i] + " ..match found ? " + str(match_found)
			# 		print "remaining word is " + remaining_word
			# 		
			if(match_found and self.find_sub_match(remaining_word, True)):
				# print "returning true since all matched"
				return True
			else:
				i += 1
			# 	continue
			# 
			# i += 1

		return False

	
	def match(self,word):
		return word in self.words
		# self.words.member?(word)

filename = sys.argv[1] if len(sys.argv) > 1 else ""
w = WordMatcher.load_from_file(filename)
print "min length is " + str(w.min_length)
w.find()
print "longest word is - " + str(w.longest_match())
print "Total count of matching long words from words - " + str(w.all_matched_words_count)

# print "Hello, World!" 
