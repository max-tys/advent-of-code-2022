# ------------ part 1 ------------

# initial parse
monkeys = File.read("input/day_11.in").split("\n\n")
        .map { |monkey| monkey.split("\n").map(&:strip) }

# detailed parse - convert monkey into hashes
monkeys.map! do |monkey|
  hash = {}
  
  hash[:id] = monkey[0].split(" ").last.to_i
  
  hash[:items] = monkey[1].scan(/(\d+)/).flatten.map(&:to_i)
  
  code = monkey[2].scan(/= (.+)/).flatten.first
  hash[:operation] = Proc.new { |old| eval(code) } # e,g, monkey[:operation].call(19) where 19 is the value for old

  hash[:divisor] = monkey[3].scan(/(\d+)/).flatten.first.to_i

  hash[:true] = monkey[4].scan(/(\d+)/).flatten.first.to_i

  hash[:false] = monkey[5].scan(/(\d+)/).flatten.first.to_i

  hash
end

inspected = Hash.new(0)

# iterate keep away over 20 rounds
1.upto(20) do
  monkeys.each do |monkey|
    monkey[:items].each do |item|
      # determine initial worry level
      worry = monkey[:operation].call(item)

      # monkey gets bored, worry level decreases
      worry = worry / 3

      # determine which monkey should receive the current item
      if (worry % monkey[:divisor]).zero?
        next_monkey = monkey[:true]
      else
        next_monkey = monkey[:false]
      end
      
      # pass the item to the next monkey
      monkeys[next_monkey][:items].push(worry)

      # increment this monkey's inspected count
      inspected[monkey[:id]] += 1
    end

    # remove the inspected items from the current monkey before moving onto the next monkey
    inspected[monkey[:id]].times do
      monkey[:items].shift
    end
  end
end

p inspected.values.max(2).reduce(:*)

# ------------ part 2 ------------

# initial parse
monkeys = File.read("input/day_11.in").split("\n\n")
        .map { |monkey| monkey.split("\n").map(&:strip) }

# detailed parse - convert monkey into hashes
monkeys.map! do |monkey|
  hash = {}
  
  hash[:id] = monkey[0].split(" ").last.to_i
  
  hash[:items] = monkey[1].scan(/(\d+)/).flatten.map(&:to_i)
  
  code = monkey[2].scan(/= (.+)/).flatten.first
  hash[:operation] = Proc.new { |old| eval(code) } # e,g, monkey[:operation].call(19) where 19 is the value for old

  hash[:divisor] = monkey[3].scan(/(\d+)/).flatten.first.to_i

  hash[:true] = monkey[4].scan(/(\d+)/).flatten.first.to_i

  hash[:false] = monkey[5].scan(/(\d+)/).flatten.first.to_i

  hash
end

# calculate the product of all the divisors
# use this to reduce the worry level instead of dividing it by 3
# idea from https://www.youtube.com/watch?v=63-uEScYUvM
big_mod = 1
monkeys.each do |monkey|
  big_mod *= monkey.values_at(:divisor).first
end

inspected = Hash.new(0)

# iterate keep away over 10000 rounds
1.upto(10000) do
  monkeys.each do |monkey|
    monkey[:items].each do |item|
      # determine initial worry level
      worry = monkey[:operation].call(item)

      # determine which monkey should receive the current item
      if (worry % monkey[:divisor]).zero?
        next_monkey = monkey[:true]
      else
        next_monkey = monkey[:false]
      end
      
      # pass the modified item to the next monkey
      worry = worry % big_mod
      monkeys[next_monkey][:items].push(worry)

      # increment this monkey's inspected count
      inspected[monkey[:id]] += 1
    end

    # remove the inspected items from the current monkey before moving onto the next monkey
    inspected[monkey[:id]].times do
      monkey[:items].shift
    end
  end
end

# [122937, 20445, 122291, 62033, 32278, 1538, 122410, 122181]
p inspected.values.max(2).reduce(:*)
