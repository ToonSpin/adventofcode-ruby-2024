# frozen_string_literal: true

require_relative 'grid'

class Warehouse < Grid
  def initialize(content, instructions)
    super(content)
    @robot_x, @robot_y, = scan('@')[0]
    @instructions = instructions
    @instruction_pointer = 0
    set_cell(@robot_x, @robot_y, '.')
    @directions = { '^' => [0, -1], '>' => [1, 0], 'v' => [0, 1], '<' => [-1, 0] }
  end

  def gps
    scan('O').map { |x, y, _| x + (y * 100) }.sum
  end

  def bump_instruction
    instruction = @instructions[@instruction_pointer]
    @instruction_pointer = (@instruction_pointer + 1) % @instructions.length
    instruction
  end

  def iterate(count)
    (1..count).each { iterate_single }
  end

  def iterate_single
    p, q = @directions[bump_instruction]
    next_x = @robot_x + p
    next_y = @robot_y + q

    c = get_cell(next_x, next_y)

    return if c == '#'

    if c == '.'
      @robot_x = next_x
      @robot_y = next_y
      return
    end

    test_x = next_x + p
    test_y = next_y + q
    loop do
      c = get_cell test_x, test_y
      return if c == '#'

      if c == '.'
        set_cell(test_x, test_y, 'O')
        set_cell(next_x, next_y, '.')
        @robot_x = next_x
        @robot_y = next_y
        return
      end
      test_x += p
      test_y += q
    end
  end
end

file_path = ARGV[0]
file = File.open(file_path, 'r')
wh_data, ins_data = file.read.split("\n\n")

instructions = ins_data.split("\n").map(&:chars).flatten
warehouse = Warehouse.new(wh_data, instructions)

warehouse.iterate instructions.length
puts warehouse.gps
