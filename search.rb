require 'pry'

str = File.read("haystack.txt")
@pattern = "the"
counter = 0

while str.include?(@pattern)
  counter += 1
  str = str.match(@pattern).post_match
end

puts counter
