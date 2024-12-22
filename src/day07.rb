# frozen_string_literal: true

class Equation
  attr_reader :test_value

  def initialize(line)
    test_value, operands = line.strip.split(': ')
    @test_value = test_value.to_i
    @operands = operands.split.map(&:to_i)
  end

  def possible_part_one?
    possible?(false, @test_value, @operands.clone)
  end

  def possible_part_two?
    possible?(true, @test_value, @operands.clone)
  end

  def add_possible?(part_two, aggregate, operands)
    return false unless aggregate >= operands.last

    operand = operands.pop
    possible?(part_two, aggregate - operand, operands.clone)
  end

  def mul_possible?(part_two, aggregate, operands)
    return false unless (aggregate % operands.last).zero?

    operand = operands.pop
    possible?(part_two, aggregate / operand, operands.clone)
  end

  def concat_possible?(part_two, aggregate, operands)
    return false unless part_two

    operand = operands.pop

    digits = Math.log10(operand).to_i + 1
    p10 = 10**digits
    return false unless aggregate % p10 == operand

    possible?(part_two, aggregate / p10, operands.clone)
  end

  def possible?(part_two, aggregate, operands)
    return operands[0] == aggregate if operands.length == 1
    return true if concat_possible?(part_two, aggregate, operands.clone)
    return true if mul_possible?(part_two, aggregate, operands.clone)

    add_possible?(part_two, aggregate, operands.clone)
  end
end

file_path = ARGV[0]
file = File.open(file_path, 'r')

equations = file.map { |line| Equation.new(line) }

puts equations.filter(&:possible_part_one?).map(&:test_value).sum
puts equations.filter(&:possible_part_two?).map(&:test_value).sum
