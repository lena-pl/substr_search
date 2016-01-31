str = "This is an example of how many occurances of the substring 'of' exist in this long string of words."
pattern = "of"
counter = 0

while str.include?(pattern)
  counter += 1
  str = str.match(pattern).post_match
end

puts counter
