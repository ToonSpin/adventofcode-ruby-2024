# frozen_string_literal: true

file_path = ARGV[0]
file = File.open(file_path, 'r')

sum_part_one = 0
sum_part_two = 0

enabled = true
file.each do |line|
  line.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/).each do |result|
    case result
    in 'do()'
      enabled = true
    in 'don\'t()'
      enabled = false
    else
      result.match(/mul\((\d+),(\d+)\)/)
      product = Regexp.last_match(1).to_i * Regexp.last_match(2).to_i
      sum_part_one += product
      sum_part_two += product if enabled
    end
  end
end

puts sum_part_one
puts sum_part_two
