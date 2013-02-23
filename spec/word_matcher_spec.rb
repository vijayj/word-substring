require 'spec_helper'
require_relative '../lib/word_matcher'

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
    let(:list2) { %w(aal aar) }
    
    it "should return nothing" do
      w = WordMatcher.new(list).find
      w.longest_match.should be_nil
    end
  end
  
  context "word match but no subwords" do
    # let(:list){ %w( cat cats catsdogcats catxdogcatsrat dog dogcatsdog hippopotamuses rat ratcatdogcat )     }
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
  end
  
  context "count all matched words" do
    it "should return a count" do
      pending
    end
  end
  
end