# --- Day 3: Rucksack Reorganization ---

sacks = File.read('input/day_3.txt').split("\n")

ORDER = ('a'..'z').to_a + ('A'..'Z').to_a

# --- Solution for Part 1 ---

# Split sack into compartments
def split_sack(sack)
  sack_size = sack.size
  sack_one = sack[0...(sack_size / 2)]
  sack_two = sack[(sack_size / 2)...sack_size]
  [sack_one.split(''), sack_two.split('')]
end

# Find the single common item between the two compartments
def find_common_item(compartments)
  (compartments.first & compartments.last).first
end

# Find the common item between a sack's two compartments
# Convert the common item to its priority number
# Create a new array of priority numbers
item_priorities = sacks.map do |sack|
  item = find_common_item(split_sack(sack))
  ORDER.index(item) + 1
end

puts "The sum of the priorities of all the common items is #{item_priorities.sum}."

# --- Solution for Part 2 ---

# Split all the sacks into groups of three
grouped_sacks = sacks.each_slice(3).to_a

# Find the 'badge' (or the common item) in each group of 3 sacks
def find_overlap_in_group(group)
  group = group.map { |sack| sack.split('') }
  (group.first & group[1] & group.last).first
end

# Find the badge in each group of three sacks
# Convert the badge to its priority number
# Create a new array of priority numbers
badge_priorities = grouped_sacks.map do |group|
  badge = find_overlap_in_group(group)
  ORDER.index(badge) + 1
end

puts "The sum of the priorities of all the badges is #{badge_priorities.sum}."
