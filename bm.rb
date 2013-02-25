require 'benchmark'

p "string slicing code"
s = "a"*1000000
n = 50000*10
Benchmark.bmbm do |x|
  x.report("str slice") { for i in 1..n; s[0,i] ; end }
  x.report("str range") { for i in 1..n; s[0..i] ; end }
  x.report("str array") { for i in 1..n; s.slice(0,i) ; end }
end



exit

p "set vs hash"

require 'set'
a = (1..100000).to_a
s = Set.new(a)
h = Hash.new
a.each { |e| h[e] = true}

require 'benchmark'

n = 500000
Benchmark.bmbm do |x|
  x.report("set:") { for i in 1..n; s.member?(i) ; end }
  x.report("set include:") { for i in 1..n; s.include?(i) ; end }
  x.report("hash include:") { for i in 1..n; h.include?(i) ; end }
  x.report("hash dma:") { for i in 1..n; h[i] ; end }
end