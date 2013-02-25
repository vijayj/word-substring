require 'spec_helper'
require_relative '../lib/word_matcher'
require 'benchmark'

describe "WordMatcherSpec" do

  context "no words" do
    let(:list){ [] }
    it "should return nothing" do
      w = WordMatcher.new(list).find
      w.longest_match.should be_nil
    end
  end

  context "all words are equal, no matches" do
    let(:list){ %w(bat cat dog) }

    it "should return nothing" do
      w = WordMatcher.new(list).find
      w.longest_match.should be_nil
    end
  end

  context "word match but no subwords" do
    let(:list){ %w( cat cats catsdogcats catxdogcatsrat dog rat ratcatdogcat )     }

    it "should return ratdogcat" do
      w = WordMatcher.new(list).find
      w.longest_match.should == "ratcatdogcat"
    end
  end

  context "word with one character match" do
    let(:list) { %w(a aa aar b bapd c d d dex  r) }

    it "should return aar" do
      w = WordMatcher.new(list).find
      w.longest_match.should == "aar"
    end
  end

  context "word match with many subwords match" do
    let(:list){ %w(bat cat cats dog rat ratdogcat ratcatsdog t ttttt) }

    it "should return ratcatsdog" do
      w = WordMatcher.new(list).find
      w.longest_match.should == "ratcatsdog"
    end
  end


  context "using a file of words" do
    before(:each) do
      @list = []
      File.open(File.join(File.dirname(__FILE__), "fixtures", "words_for_problem.txt")).each_line do |l|
        @list << l.chomp
      end
    end

    it "should return longest word" do
      w = WordMatcher.new(@list).find
      w.longest_match.should == "ethylenediaminetetraacetates"

    end

    it "should return longest word file name " do
      filename = File.join(File.dirname(__FILE__), "fixtures", "words_for_problem.txt")
      w = WordMatcher.load_from_file(filename).find
      w.longest_match.should == "ethylenediaminetetraacetates"
    end
  end

  context "count all matched words" do
    it "should return a count of zero when word list is empty" do
      list = []
      w = WordMatcher.new(list).find
      w.all_matched_words_count.should == 0
    end

    it "should return a count of zero if no words match" do
      list = %w(bat cat dog)
      w = WordMatcher.new(list).find
      w.all_matched_words_count.should == 0
    end

    it "should return a count of 1 if only one word matches" do
      list = %w(bat cat cats dog rat ratdogcat  ta ttttt)
      w = WordMatcher.new(list).find
      w.all_matched_words_count.should == 1
    end

    it "should return a count of word matches for a given file" do
      filename = File.join(File.dirname(__FILE__), "fixtures", "words_for_problem.txt")
      w = WordMatcher.load_from_file(filename).find
      w.all_matched_words_count.should == 97107
    end
  end
end


describe "WordMatcherSpec Benchmarks", :benchmarks => true do
  
  it "should return longest word benchmarked for just words" do
    @list = []
    File.open(File.join(File.dirname(__FILE__), "fixtures", "words_for_problem.txt")).each_line do |l|
      @list << l.chomp
    end
    
    n = 10
    Benchmark.bmbm do |x|
      x.report("algo:") do
        for i in 1..n do
          w = WordMatcher.new(@list).find
          w.longest_match.should == "ethylenediaminetetraacetates"
          w.all_matched_words_count.should == 97107
        end
      end
    end
  end

  it "should return longest word benchmarked when reading a file" do
    n = 10
    Benchmark.bmbm do |x|
      filename = File.join(File.dirname(__FILE__), "fixtures", "words_for_problem.txt")
      x.report("algo_file:") do
        for i in 1..n do
          w = WordMatcher.load_from_file(filename).find
          w.longest_match.should == "ethylenediaminetetraacetates"
          w.all_matched_words_count.should == 97107
        end
      end
    end
  end
end
  
