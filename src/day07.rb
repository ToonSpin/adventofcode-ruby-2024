require 'strscan'

class Equation
  attr_reader :test_value

  def initialize(line)
    test_value, operands = line.strip.split(': ')
    @test_value = test_value.to_i
    @operands = operands.split.map {|s| s.to_i}
  end

  def possible?(part_two = false, aggregate = @test_value, operands = @operands.clone)
    operand = operands.pop

    if operands.length == 0
      return operand == aggregate
    end

    if part_two
      digits = Math.log10(operand).to_i + 1
      p10 = 10 ** digits
      if aggregate % p10 == operand
        return true if self.possible?(part_two, aggregate / p10, operands.clone)
      end
    end

    if aggregate % operand == 0
      return true if self.possible?(part_two, aggregate / operand, operands.clone)
    end

    if aggregate >= operand
      return true if self.possible?(part_two, aggregate - operand, operands.clone)
    end

    return false
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")

equations = []
file.each do |line|
  equations << Equation.new(line)
end

puts equations.filter {|e| e.possible?}.map {|e| e.test_value}.sum
puts equations.filter {|e| e.possible?(true)}.map {|e| e.test_value}.sum
