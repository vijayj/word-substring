require 'optparse'
require_relative './word_matcher'

class Match
  def initialize(filename)
    @word_file = filename || ""
  end

  def run
    list = []
    w = WordMatcher.load_from_file(@word_file)
    w.find
    p w.longest_match
    p w.all_matched_words_count
  rescue Errno::ENOENT => e
    p "Seems like we have a missing file. please pass in a valid file"
  end
end


options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ruby match.rb [options]"

  opts.on("-f", "--filename FILENAME", "file with words") do |f|
    options[:filename] = f
  end
end


begin
  optparse.parse!
  if options[:filename].nil?
    puts optparse
    puts exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts e.to_s
  puts optparse
  exit
end


puts "Starting matcher with arguments: #{options.inspect}"
Match.new(options[:filename]).run


