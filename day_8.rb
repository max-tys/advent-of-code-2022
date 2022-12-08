# 99 x 99 grid
grid = File.read('input/day_8.in').split("\n").map do |row|
  row = row.chars
  row.map(&:to_i)
end

# tracks coordinates of visible trees
visible = []

# returns an entire column
def col(grid, col_number)
  column = []
  grid.each { |row| column << row[col_number] }
  column
end

# yields every row and col
def each_row_with_index(grid, &block)
  grid.each_with_index(&block)
end

def each_col_with_index(grid)
  (0...grid.first.size).each_with_index do |col_number, idx|
    yield col(grid, col_number), idx
  end
end

# adds a tree's coordinates to an array if it is visible
# reject insertion if the tree has been seen elsewhere
def add(visible, x, y)
  visible << [x, y] unless visible.include? [x, y]
end

########## PART 1 ##########
# scan the grid from the left
each_row_with_index(grid) do |row, y|
  max_h = -1
  row.each_with_index do |tree_h, x|
    if tree_h > max_h
      add(visible, x, y)
      max_h = tree_h
    end
    break if max_h == 9
  end
end

# scan the grid from the right
each_row_with_index(grid) do |row, y|
  row = row.reverse
  max_h = -1
  row.each_with_index do |tree_h, x|
    if tree_h > max_h
      x = (row.size - 1) - x
      add(visible, x, y)
      max_h = tree_h
    end
    break if max_h == 9
  end
end

# scan the grid from the top
each_col_with_index(grid) do |col, x|
  max_h = -1
  col.each_with_index do |tree_h, y|
    if tree_h > max_h
      add(visible, x, y)
      max_h = tree_h
    end
    break if max_h == 9
  end
end

# scan the grid from the bottom
each_col_with_index(grid) do |col, x|
  col = col.reverse
  max_h = -1
  col.each_with_index do |tree_h, y|
    if tree_h > max_h
      y = (col.size - 1) - y
      add(visible, x, y)
      max_h = tree_h
    end
    break if max_h == 9
  end
end

puts "Part 1: There are #{visible.count} visible trees."

########## PART 2 ##########

# returns trees from the specified direction
def left_trees(grid, x, y)
  grid[y][0...x]
end

def right_trees(grid, x, y)
  grid[y][(x + 1)..]
end

def top_trees(grid, x, y)
  col(grid, x)[0...y]
end

def bottom_trees(grid, x, y)
  col(grid, x)[(y + 1)..]
end

# returns a view distance for a tree in a specified direction
def left_view_distance(grid, x, y)
  points = 0
  tree_h = grid[x][y]
  left_trees(grid, x, y).reverse.each do |other_h|
    points += 1
    break if tree_h <= other_h
  end
  points
end

def right_view_distance(grid, x, y)
  points = 0
  tree_h = grid[x][y]
  right_trees(grid, x, y).each do |other_h|
    points += 1
    break if tree_h <= other_h
  end
  points
end

def top_view_distance(grid, x, y)
  points = 0
  tree_h = grid[x][y]
  top_trees(grid, x, y).reverse.each do |other_h|
    points += 1
    break if tree_h <= other_h
  end
  points
end

def bottom_view_distance(grid, x, y)
  points = 0
  tree_h = grid[x][y]
  bottom_trees(grid, x, y).each do |other_h|
    points += 1
    break if tree_h <= other_h
  end
  points
end

def scenic_score(grid, x, y)
  left_view_distance(grid, x, y) *
    right_view_distance(grid, x, y) *
    top_view_distance(grid, x, y) *
    bottom_view_distance(grid, x, y)
end

# tracks scenic scores for every coordinate
scenic_scores = Hash.new(0)

# iterate over every single tree in the forest
# compute scenic score for a tree, add it to the hash
grid.each_with_index do |row, y|
  row.each_index do |x|
    scenic_scores[[x, y]] = scenic_score(grid, x, y)
  end
end

puts "Part 2: The highest possible scenic score is #{scenic_scores.values.max}."
