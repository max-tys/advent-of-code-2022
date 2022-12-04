# convert string range into arrays
# e.g. "2-4" -> [2, 3, 4]
def range_to_array(range)
  first, second = range.split('-').map(&:to_i)
  (first..second).to_a
end

# checks if any range in a pair is fully contained by the other range
def contained?(pair)
  r1 = range_to_array(pair.first)
  r2 = range_to_array(pair.last)

  (r1 - r2).empty? || (r2 - r1).empty?
end

# checks if the ranges in a pair overlap each other
# if there's no overlap, Array#& returns an empty array
def overlapped?(pair)
  r1 = range_to_array(pair.first)
  r2 = range_to_array(pair.last)

  !(r1 & r2).empty?
end

# convert raw input into array of arrays
# e.g. 83-83,45-82 -> [[83-83], [45-82]]
pairs = File.read('input/day_4.txt').split("\n")
pairs.map! { |pair| pair.split(',')}

# part 1
contained = pairs.count { |pair| contained? pair }
puts "Part 1: One range fully contains the other in #{contained} pairs."

# part 2
overlapped = pairs.count { |pair| overlapped? pair }
puts "Part 2: The ranges overlap in #{overlapped} pairs."