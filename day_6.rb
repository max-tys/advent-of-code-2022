buffer = File.read('input/day_6.txt')

def find_start_position(buffer, marker_size)
  idx = 0
  while idx <= buffer.size - marker_size
    slice = buffer[idx, marker_size]
    return (idx + marker_size) if slice.chars.uniq.size == marker_size

    idx += 1
  end
end

puts "#{find_start_position(buffer,
                            4)} characters need to be processed before the first start-of-packet marker is detected."

puts "#{find_start_position(buffer,
                            14)} characters need to be processed before the first start-of-message marker is detected."

# test_buffers = [
#   "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
#   "bvwbjplbgvbhsrlpgdmjqwftvncz",
#   "nppdvjthqldpwncqszvftbrmjlhg",
#   "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
#   "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
# ]

# test_buffers.each do |buffer|
#   p "#{buffer}: #{find_start_position(buffer, 14)}"
# end
