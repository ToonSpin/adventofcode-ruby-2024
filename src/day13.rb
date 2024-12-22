# frozen_string_literal: true

class Machine
  def initialize(content)
    content.match(/^Button A: X\+(\d+), Y\+(\d+)$/)
    @a = [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i]

    content.match(/^Button B: X\+(\d+), Y\+(\d+)$/)
    @b = [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i]

    content.match(/^Prize: X=(\d+), Y=(\d+)$/)
    @prize = [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i]
  end

  def token_cost(part_two: false)
    v, w = @a
    x, y = @b
    p, q = @prize

    if part_two
      p += 10_000_000_000_000
      q += 10_000_000_000_000
    end

    i = (p * y) - (q * x)
    j = (q * v) - (p * w)
    d = (v * y) - (w * x)

    return 0 if i % d != 0 || j % d != 0

    ((3 * i) + j) / d
  end
end

file_path = ARGV[0]
file = File.open(file_path, 'r')

machines = file.read.split("\n\n").map { |content| Machine.new content }

puts machines.map { |m| m.token_cost(part_two: false) }.sum
puts machines.map { |m| m.token_cost(part_two: true) }.sum
