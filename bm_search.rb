require 'pry'
# Boyer–Moore–Horspool algorithm

# ===================
# bad character rule
# ===================

def bc_table(pattern)
  bc_keys = pattern.chars.uniq
  table = bc_keys.map {|key| [key, move_by_value(pattern, key)]}

  h = Hash[*table.flatten]
  h.store("*","#{pattern.length}")
  h
end

def move_by_value(pattern, key)
  # max (1, length - 1 - index)
  value = [pattern.length - 1 - last_index_of(pattern, key), 1].max
end

def last_index_of(pattern, char)
  array_of_occurances = pattern.enum_for(:scan,char).map { Regexp.last_match.begin(0) }
  array_of_occurances.sort.last
end

# =============================
# boyer moore horspool search
# =============================

def horspool(pattern, text)
  # print text
  # start at the first char
  # compare last char of pattern with corresponding char of text
  pattern_index = position = pattern.length - 1

  visits = Hash.new(false)

  while text.length - position >= pattern.length - (pattern.length - 2)

    if visits[[position, pattern_index]]
      while text[position] == pattern.chars.last
        position += 1
      end
      pattern_index = pattern.length - 1
    else
      visits[[position, pattern_index]] = true
    end

    if text[position] == pattern[pattern_index]
      #match
      #are all characters matched?
      if pattern_index == 0 || pattern_index == - pattern.length
        return position
      end
      #compare next char
      position -= 1
      pattern_index -=1
    elsif pattern.include?(text[position])
      #mismatch in table
      #shift by that much
      position += bc_table(pattern)[text[position]]
      pattern_index = pattern.length - 1
    else
      #mismatch not in table
      #shift whole length of pattern
      position += pattern.length
      pattern_index = pattern.length - 1
    end
  end

end

# =============================
# looping search and count
# =============================

def occurances_count(text, pattern)
  text = text
  counter = 0

  loop do

    hors = horspool(pattern, text)


    if hors
      last_found_index = hors + pattern.length
      text = text[last_found_index..-1]
      counter += 1
    else
      return counter
    end
  end

  counter
end

haystack = File.read("haystack.txt")

needle = "\""

puts "RESULT: #{occurances_count(haystack, needle)}"
