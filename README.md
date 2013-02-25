How to run

unzip the directory
Ensure you have ruby 1.9.3
Install the bundler gem
run bundle install to install gems (I used pry and rspec)
run ruby lib/match.rb -f spec/fixtures/words_for_problem.txt 


Tests
rake -T will show all tasks
To run default tests, run rake spec . There are 2 tests in the spec class that read the entire input

Benchmark tests
run rake spec_with_benchmarks
There are 2 tests. The first one assumes that word list is created by another class and passed to the matcher.
The second one reads the file in the class. I have found that reading the file in with ruby is slow


Approach

I thought about using tries - suffix tries but tries were not that fast. Then I tried a simple approach of having 2 lists. 

The first run I had took approximately 5.7 seconds to run. After a series of optimizations including inferring about minmal length the final optimization for the program running time is about 3.6 seconds - a savings of 36%. I realized that this program has no i/o, network calls so parallelization would not provide any speed gains. I also validated my hypothesis using parallel gem (The run time increased by more than double the standard running time)

I have written code to handle empty lists, lists with no match and the given file. It is comprehensive enough to cover cases.


Learnings:
It seems to me that ranges in ruby are slow. I used ranges extensively in my for loop.  I changed it to until loop. 
Used min word length optimization to reduce calls to find matching words and in the recursive loop
I also changed implementation of Set to Hash as Set is backed by Hash and therefore incurs a very slight performance overhead ( found it using ruby-prof ) over simple hash.



Points to consider
There are 2 empty lines at the end of the file. I am considering them as one empty string. I have removed them but then I was not sure if that was an input

