# parse program
require 'pry'

program = File.read('input/day_10.in').split("\n")

# ------------ Part 1 ------------ 
=begin
cycle = 1
x = 1
KEY_CYCLES = [20, 60, 100, 140, 180, 220]
sig_str = []

prog.each do |line|
  line = line.split(' ')

  # at the start of the cycle, do nothing regardless of whether the instruction is noop or addx

  # at the end of the cycle, increase cycle count by one
  cycle += 1
  sig_str << (cycle * x) if KEY_CYCLES.include? cycle
  
  # if the instruction was noop, move on to the next instruction 
  # if the instruction was addx, execute its instruction in the next cycle
  if line.first == 'addx'
    # at the start of the next cycle, do nothing
    # literally nothing

    # at the end of the next cycle, execute addx
    cycle += 1
    x += line.last.to_i
    sig_str << (cycle * x) if KEY_CYCLES.include? cycle
  end
end

p sig_str.sum
=end

# ------------ Part 2 ------------ 
# CRT draws a notional pixel at the start of each cycle
# sprites only move at the end of each cycle
# only if sprite and pixel coincide, the pixel is lit up

# todo: there's probably a better way to initialize the screen...
screen = [(' ' * 40).chars, (' ' * 40).chars, (' ' * 40).chars, (' ' * 40).chars, (' ' * 40).chars, (' ' * 40).chars]
cycle = 1
x = 1

program.each do |instruction|
  instruction = instruction.split(' ')

  # at the start of the cycle, determine if pixel and sprite coincide
  row, pixel = (cycle - 1).divmod(40)
  sprite = [x - 1, x, x + 1]
  # todo: this can probably be refactored?
  if sprite.include? pixel
    screen[row][pixel] = '#'
  else 
    screen[row][pixel] = '.'
  end

  # at the end of the cycle, increase cycle count by one
  cycle += 1
  
  # if the instruction was noop, move on to the next instruction 
  # if the instruction was addx, execute its instruction in the next cycle
  if instruction.first == 'addx'
    # at the start of the next cycle, determine if pixel and sprite coincide
    row, pixel = (cycle - 1).divmod(40)
    sprite = [x - 1, x, x + 1]
    # todo: this can probably be refactored too.
    if sprite.include? pixel 
      screen[row][pixel] = '#'
    else 
      screen[row][pixel] = '.'
    end

    # at the end of the next cycle, execute addx
    cycle += 1
    x += instruction.last.to_i
  end
end

puts screen.map(&:join)
