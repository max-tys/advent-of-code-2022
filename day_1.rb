# convert raw input into array of strings (or 'sacks')
# each sack contains the calorific values of the snacks
sacks = File.read('input/day_1.txt').split("\n\n")

# transform each string into an integer sum of the calorific values
sacks.map! do |sack|
  sack.split("\n")
      .map(&:to_i)
      .sum
end

puts "There are #{sacks.size} elves."
puts "The greatest number of calories carried by an elf is #{sacks.max}."
puts "The number of calories carried by the top three elves is #{sacks.max(3).sum}."
