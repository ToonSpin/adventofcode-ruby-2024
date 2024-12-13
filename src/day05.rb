def update_matches?(update, rule)
  first, second = rule
  update.each_with_index do |page, i|
    next if page != first
    update.each_with_index do |other, j|
      next if other != second
      return false if j < i
    end
  end
  return true
end

def update_matches_all?(update, rules)
  rules.all? {|rule| update_matches? update, rule}
end

def compare_update(a, b, rules)
  rules.each do |rule|
    first, second = rule
    return -1 if first == a && second == b
    return 1 if first == b && second == a
  end
  return 0
end

def sort_update!(update, rules)
  result = update
  result.sort! { |a, b| compare_update(a, b, rules) }
end

file_path = ARGV[0]
file = File.open(file_path, "r")
input = file.read

rules = []
input.scan(/(\d+)\|(\d+)/).each do |a, b|
  rules << [a.to_i, b.to_i]
end

updates = []
input.scan(/^(\d+(,\d+)*)$/).each do |update, _|
  updates.push update.split(',').map {|s| s.to_i}
end

sum_correct = 0
sum_incorrect = 0
updates.each do |update|
  index = update.length / 2
  if update_matches_all?(update, rules)
    sum_correct += update[index]
  else
    sort_update!(update, rules)
    sum_incorrect += update[index]
  end
end
puts sum_correct
puts sum_incorrect
