def safe_in_order?(report, lower, upper)
  for i in 0...(report.length - 1)
    d = report[i + 1] - report[i]
    if d < lower || d > upper
      return false
    end
  end
  return true
end

def safe_part_one?(report, lower, upper)
  return true if safe_in_order?(report, lower, upper)
  return safe_in_order?(report.reverse, lower, upper)
end

def safe_part_two?(report, lower, upper)
  return true if safe_part_one?(report, lower, upper)
  for i in 0...report.length
    omitted = report[0...i] + report[i+1..report.length]
    return true if safe_part_one?(omitted, lower, upper)
  end
  return false
end

file_path = ARGV[0]
file = File.open(file_path, "r")
lines = file.read.split("\n")
reports = lines.map { |l| l.strip.split(' ').map { |n| n.to_i } }

puts reports.filter { |r| safe_part_one? r, 1, 3 }.length
puts reports.filter { |r| safe_part_two? r, 1, 3 }.length
