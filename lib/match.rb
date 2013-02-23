require 'optparse'
require_relative './word_matcher'

class Match
  def initialize(filename)
    @word_file = filename || ""
  end

  def run
    list = []
    File.open(@word_file).each_line { |l| list << l.chomp }
    w = WordMatcher.new(list).find
    p w.longest_match
    p w.all_found_word_count
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


