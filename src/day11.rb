# frozen_string_literal: true

file_path = ARGV[0]
file = File.open(file_path, 'r')

memo = {}

def stone_count_single(stone)
  return 1 if stone.zero?

  num_digits = Math.log10(stone).floor + 1
  return 2 if (num_digits % 2).zero?

  1
end

def stone_count_compute(stone, iter, memo)
  return stone_count_single(stone) if iter == 1
  return stone_count(1, iter - 1, memo) if stone.zero?

  num_digits = Math.log10(stone).floor + 1
  return stone_count(stone * 2024, iter - 1, memo) unless (num_digits % 2).zero?

  factor = 10**(num_digits / 2)
  left, right = stone.divmod factor
  stone_count(left, iter - 1, memo) + stone_count(right, iter - 1, memo)
end

def stone_count(stone, iter, memo)
  key = [stone, iter]
  memo[key] = stone_count_compute(stone, iter, memo) unless memo.include?(key)
  memo[key]
end

input = file.read.split.map(&:to_i)

puts input.map { |stone| stone_count(stone, 25, memo) }.sum
puts input.map { |stone| stone_count(stone, 75, memo) }.sum
