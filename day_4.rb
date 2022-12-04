# Converts a '-' delimited string range into a Range object
def string_to_range(str)
  n1, n2 = str.split('-').map(&:to_i)
  Range.new(n1, n2)
end

# checks if any range in a pair is fully contained by the other range
def contained?(ranges)
  r1, r2 = ranges.first, ranges.last
  r1.cover?(r2) || r2.cover?(r1)
end

# checks if the ranges in a pair overlap each other
# if there's no overlap, Array#& returns an empty array
def overlapped?(ranges)
  r1, r2 = ranges.first, ranges.last
  ! (r1.last < r2.first || r1.first > r2.last)
end

# convert raw input into array of array of ranges
# e.g. "83-83,45-82" -> ['83-83', '45-82'] -> ['83'..'83', '45'..'82'] 
pairs = File.read('input/day_4.txt').split("\n")

pairs.map! { |pair| pair.split(',') }
     .map! { |pair| [string_to_range(pair.first), string_to_range(pair.last)] }

# part 1
contained = pairs.count { |pair| contained? pair }
puts "Part 1: One range fully contains the other in #{contained} pairs."

# part 2
overlapped = pairs.count { |pair| overlapped? pair }
puts "Part 2: The ranges overlap in #{overlapped} pairs."