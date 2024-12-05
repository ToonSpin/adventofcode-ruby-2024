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

sum = 0
updates.each do |update|
  if update_matches_all?(update, rules)
    index = update.length / 2
    sum += update[index]
  end
end
puts sum
