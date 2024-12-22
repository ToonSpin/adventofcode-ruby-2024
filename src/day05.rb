# frozen_string_literal: true

def update_matches?(update, first, second)
  first_index = update.index(first)
  second_index = update.index(second)
  first_index.nil? || second_index.nil? || first_index < second_index
end

def update_matches_all?(update, rules)
  rules.all? { |first, second| update_matches?(update, first, second) }
end

def compare_pages(a, b, rules)
  rules.each do |first, second|
    return -1 if first == a && second == b
    return 1 if first == b && second == a
  end
  0
end

def sort_update!(update, rules)
  update.sort! { |a, b| compare_pages(a, b, rules) }
end

file_path = ARGV[0]
file = File.open(file_path, 'r')
input = file.read

rules = input.scan(/(\d+)\|(\d+)/).map { |a| a.map(&:to_i) }
updates = input.scan(/^(\d+(,\d+)*)$/).map { |update,| update.split(',').map(&:to_i) }

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
