# Parse the stacks drawing
def parse_stacks(stack_input)
  lines = stack_input.map(&:chars)

  stacks = Hash.new { |hash, key| hash[key] = [] }

  lines.each do |line|
    line.each_slice(4).with_index do |slice, idx|
      item = slice.select { |char| char.match?(/[A-Z]/)}
      stacks[idx + 1] << item unless item.empty?
    end
  end

  stacks
end

# Part 1: CraneMover 9000 moves crates one at a time
def move_singly!(move, stacks)
  move = move.scan(/(\d+)/).flatten.map(&:to_i)
  
  move[0].times do
    item = stacks[move[1]].shift
    stacks[move[2]].prepend item
  end
end

stacks, moves = File.read('input/day_5.txt').split("\n\n").map { |x| x.split("\n") }
stacks = parse_stacks(stacks)
moves.each { |move| move_singly!(move, stacks) }

top_stack = (1..9).each_with_object([]) { |n, arr| arr << stacks[n].first}.join
puts "Part 1: When using CrateMover 9000, the crates on top of each stack are '#{top_stack}'."

# Part 2: CraneMover 9001 moves multiple crates at once
def move_together!(move, stacks)
  move = move.scan(/(\d+)/).flatten.map(&:to_i)
  
  items = stacks[move[1]].shift(move[0])
  stacks[move[2]].prepend items
  stacks[move[2]].flatten!
end

stacks, moves = File.read('input/day_5.txt').split("\n\n").map { |x| x.split("\n") }
stacks = parse_stacks(stacks)
moves.each { |move| move_together!(move, stacks) }

top_stack = (1..9).each_with_object([]) { |n, arr| arr << stacks[n].first}.join
puts "Part 2: When using CrateMover 9001, the crates on top of each stack are '#{top_stack}'."
