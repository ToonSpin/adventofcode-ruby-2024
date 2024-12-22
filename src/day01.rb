# frozen_string_literal: true

file_path = ARGV[0]
file = File.open(file_path, 'r')

left, right = file.map { |line| line.split.map(&:to_i) }.transpose
puts left.sort.zip(right.sort).map { |a, b| (b - a).abs }.sum
puts left.map { |n| n * right.count { |m| m == n } }.sum
