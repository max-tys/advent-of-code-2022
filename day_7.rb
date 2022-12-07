terminal = File.read('input/day_7.txt')

terminal = terminal.split("\n$ ")[1..].map {|line| line.split("\n")}

path = []

dir_sizes = Hash.new(0)
children = Hash.new { |hash, key| hash[key] = [] }

def parse(block)

end

terminal.each do |block|

end

# terminal.each_line(chomp: true) do |line|
#   if line.match? /^\$ cd/ # changing directory
#     new_dir = line.split.last

#     if new_dir == '..' # move up to parent
#       path.pop
#     else
#       path << new_dir
#     end
#   elsif line.match? /^\$ ls/ # listing files
#     next
#   elsif line.match? /^\d+/ # a file is listed
#     size, name = line.split
#     File.new(pwd, size, name)
#   elsif line.match? /^dir/ # a directory is listed
#     name = line.split.last
#     pwd.add_file Directory.new(path, name)
#   end
# end

