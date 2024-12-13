class Machine
  def initialize(content)
    button_a, button_b, prize = content.split("\n")

    button_a.match /^Button .: X([+-]\d+), Y([+-]\d+)/
    @a = [$1.to_i, $2.to_i]

    button_b.match /^Button .: X([+-]\d+), Y([+-]\d+)/
    @b = [$1.to_i, $2.to_i]

    prize.match /^Prize: X=(\d+), Y=(\d+)/
    @prize = [$1.to_i, $2.to_i]
  end

  def token_cost(part_two = false)
    v, w = @a
    x, y = @b
    p, q = @prize
    if part_two
      p += 10000000000000
      q += 10000000000000
    end
    i = p * y - q * x
    j = q * v - p * w
    d = v * y - w * x
    return 0 if i % d != 0 || j % d != 0
    return (3 * i + j) / d
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")

machines = file.read.split("\n\n").map {|content| Machine.new content}

puts machines.map {|m|m.token_cost(false)}.sum
puts machines.map {|m|m.token_cost(true)}.sum
