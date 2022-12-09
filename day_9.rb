# parse moves
moves = File.read('input/day_9.in').split("\n")
            .map do |m|
              dir, steps = m.split(' ')
              [(dir * steps.to_i).split('')]
            end.flatten

# add unique, visited positions
def add(visited, position)
  visited << position unless visited.include? position
end

# determine the head's next position
def head_next(head, move)
  x, y = head
  case move
  when 'U' then [x, (y + 1)]
  when 'D' then [x, (y - 1)]
  when 'L' then [(x - 1), y]
  else          [(x + 1), y]
  end
end

# determine the subsequent knot's position
def knot_next(front, back)
  fx, fy = front
  bx, by = back

  relative = [(fx - bx), (fy - by)]
  rx, ry = relative

  # don't move if head and tail are touching
  if rx.abs < 2 && ry.abs < 2
    [bx, by]
  # move tail if it's not touching the head
  else
    [bx + rx.fdiv(2).round, by + ry.fdiv(2).round]
  end
end

# Part 1: Rope is two knots long
head = [0, 0]
tail = [0, 0]

visited = []

moves.each do |move|
  head = head_next(head, move)
  tail = knot_next(head, tail)
  add(visited, tail)
end

puts "Part 1: The tail of the rope visits #{visited.count} positions at least once."

# Part 2: Rope is ten knots long

# initialize the rope and its knots
rope = {}
knots = Array(0..9).each { |knot| rope[knot] = [0, 0] }

visited = []

moves.each do |move|
  # the input directly dictates the head's movement
  rope[0] = head_next(rope[0], move)

  # the rest of the rope follows each preceding knot
  knots.each_index do |idx|
    next if idx.zero?

    rope[idx] = knot_next(rope[idx - 1], rope[idx])
  end

  # record the tail's position after the head moves
  add(visited, rope[9])
end

puts "Part 2: The tail of the rope visits #{visited.count} positions at least once."
