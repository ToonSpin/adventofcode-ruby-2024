# frozen_string_literal: true

def safe_in_order?(report)
  report[1..].zip(report).map { |b, a| b - a }.all? { |d| d >= 1 && d <= 3 }
end

def safe_part_one?(report)
  safe_in_order?(report) || safe_in_order?(report.reverse)
end

def safe_part_two?(report)
  return true if safe_part_one?(report)

  report.each_index.any? { |i| safe_part_one?(report[...i] + report[i + 1..]) }
end

file_path = ARGV[0]
file = File.open(file_path, 'r')
reports = file.map { |l| l.split.map(&:to_i) }

puts reports.filter { |r| safe_part_one? r }.length
puts reports.filter { |r| safe_part_two? r }.length
