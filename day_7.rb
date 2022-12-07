# adapted from https://github.com/womogenes/AoC-2022-Solutions/blob/main/day_07/day_07_p1.py

class TerminalParser
  def initialize(blocks)
    @blocks = blocks

    # keeps track of the path we're in as we parse all the blocks
    @current_path = []
    
    # keep track of the size of each directory, key is abspath
    @dir_file_sizes = Hash.new(0)
    
    # for every path, we list all its child paths, key is abspath
    @children = Hash.new { |hash, key| hash[key] = [] }

    parse_all
  end

  def parse_all
    @blocks.each { |block| parse(block) }
  end

  # takes in a string, updates dir_file_sizes and children
  def parse(block) 
    lines = block.split("\n")
    
    # either cd or ls
    command, directory = lines.first.split(' ') 
    
    # everything that comes after cd or ls, empty if cd
    outputs = lines[1..]

    # keep track of directory changes with @current_path
    if command == 'cd'
      directory == '..' ? @current_path.pop : @current_path << directory
      return
    end
    
    # if we aren't changing directories,
    # join all subdirectories from the current path into a string, and assign string to abspath
    abspath = @current_path.join('/') 

    # keeps track of sizes of files in current directory
    dir_file_size = 0

    # iterate over each subdirectory and/or file
    outputs.each do |output|
      if output.match? /^dir/
        # if it's a subdirectory, add it to the list of children in our current path
        dir_name = output.split(' ').last
        @children[abspath] << "#{abspath}/#{dir_name}"
      else
        # if it's a file, add its size to dir_file_size
        dir_file_size += output.split(' ').first.to_i
      end
    end

    # update the size of the files in the current directory
    # doesn't keep track of the subdirectory sizes - use find_dir_size for that purpose
    @dir_file_sizes[abspath] = dir_file_size
  end

  # depth first search of subdirectory, returns total size of subdirectory
  def find_dir_size(abspath)
    # initialize subdirectory size to the sum of its file sizes
    @size = @dir_file_sizes[abspath]

    # obtain the total size of its subdirectories recursively
    @children[abspath].each do |child_path|
      @size += find_dir_size(child_path)
    end

    # return the total size of the subdirectory - files + subdirectories
    @size
  end

  # method for part 1
  def total_size(max: )
    answer = 0

    @dir_file_sizes.each_key do |abspath|
      answer += find_dir_size(abspath) if find_dir_size(abspath) <= max
    end

    answer
  end

  # part 2: root size
  def root_size
    ans = 0
    blocks = @blocks.reject do |block|
              block.split(' ').first == 'cd'
            end
    blocks.map! { |b| b.split }
    blocks.each do |b|
      b.reject! { |str| str.match?(/[a-z]/)}
      b.map! { |str| str.to_i }
    end
    blocks.map! do |b|
      b.sum
    end
    blocks.sum
  end

  # method for part 2
  def smallest_directory_size(add_space: )
    answer = root_size

    @dir_file_sizes.each_key do |abspath|
      if find_dir_size(abspath) >= add_space && find_dir_size(abspath) < answer
        answer = find_dir_size(abspath)
      end
    end

    answer
  end
end

f = File.read('input/day_7.txt')
blocks = f.split("\n$ ")[1..]
parser = TerminalParser.new(blocks)

# Part 1
puts "The sum of the total sizes of directories with a total size of at most 100,000 is #{parser.total_size(max: 100000)}."

# Part 2
TOTAL_DISK_SPACE = 70000000
REQUIRED_SPACE = 30000000

used_space = parser.root_size
unused_space = TOTAL_DISK_SPACE - used_space
add_space = REQUIRED_SPACE - unused_space

puts "The size of the smallest directory that, if deleted, would free up just enough space for the update is #{parser.smallest_directory_size(add_space: )}."