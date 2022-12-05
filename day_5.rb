# Converts the stacks diagram into a hash
def parse_stacks(stack_input)
  lines = stack_input.map(&:chars)

  stacks = Hash.new { |hash, key| hash[key] = [] }

  lines.each do |line|
    line.each_slice(4).with_index do |slice, idx|
      item = slice.select { |char| char.match?(/[A-Z]/) }
      stacks[idx + 1] << item unless item.empty?
    end
  end

  stacks
end

# Part 1: CraneMover 9000 moves crates one at a time
def move_singly!(move, stacks)
  tokens = move.split(' ')
  n, src, dst = [tokens[1], tokens[3], tokens[5]].map(&:to_i)

  n.times do
    item = stacks[src].shift
    stacks[dst].prepend item
  end
end

stacks, moves = File.read('input/day_5.txt').split("\n\n").map { |x| x.split("\n") }
stacks = parse_stacks(stacks)
moves.each { |move| move_singly!(move, stacks) }

top_stack = (1..9).each_with_object([]) { |n, arr| arr << stacks[n].first }.join
puts "Part 1: When using CrateMover 9000, the crates on top of each stack are '#{top_stack}'."

# Part 2: CraneMover 9001 moves multiple crates at once
def move_together!(move, stacks)
  tokens = move.split(' ')
  n, src, dst = [tokens[1], tokens[3], tokens[5]].map(&:to_i)

  items = stacks[src].shift(n)
  stacks[dst] = items + stacks[dst]
end

stacks, moves = File.read('input/day_5.txt').split("\n\n").map { |x| x.split("\n") }
stacks = parse_stacks(stacks)
moves.each { |move| move_together!(move, stacks) }

top_stack = (1..9).each_with_object([]) { |n, arr| arr << stacks[n].first }.join
puts "Part 2: When using CrateMover 9001, the crates on top of each stack are '#{top_stack}'."
