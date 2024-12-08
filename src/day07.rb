require 'strscan'

class Equation
  attr_reader :test_value

  def initialize(line)
    test_value, operands = line.strip.split(': ')
    @test_value = test_value.to_i
    @operands = operands.split.map {|s| s.to_i}
  end

  def possible?(operators = [])
    if operators.length == @operands.length - 1
      aggregate = @operands[0]
      (1...@operands.length).each do |i|
        case operators[i - 1]
        in :add
          aggregate += @operands[i]
        in :mul
          aggregate *= @operands[i]
        end
      end
      return aggregate == @test_value
    end

    return self.possible?(operators + [:add]) || self.possible?(operators + [:mul])
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")

equations = []
file.each do |line|
  equations << Equation.new(line)
end

puts equations.filter {|e| e.possible?}.map {|e| e.test_value}.sum
