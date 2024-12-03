file_path = ARGV[0]
file = File.open(file_path, "r")

sum_part_one = 0
sum_part_two = 0

enabled = true
for line in file
  for result in line.scan /mul\(\d+,\d+\)|do\(\)|don't\(\)/
    if result == 'do()'
      enabled = true
      next
    end
    if result == 'don\'t()'
      enabled = false
      next
    end

    a, b = result.match /mul\((\d+),(\d+)\)/
    product = $1.to_i * $2.to_i
    sum_part_one += product
    if enabled
      sum_part_two += product
    end
  end
end

puts sum_part_one
puts sum_part_two
