file_path = ARGV[0]
file = File.open(file_path, "r")

def process_stone(stone)
  return [1] if stone == 0
  num_digits = Math.log10(stone).floor + 1
  if num_digits % 2 == 0
    factor = 10 ** (num_digits / 2)
    return [(stone / factor).floor, stone % factor]
  end
  return [stone * 2024]
end

def iterate(input)
  return input.map{ |stone| process_stone(stone) }.flatten
end

input = file.read.strip.split.map {|s| s.to_i}

for i in 0...25
  input = iterate(input)
end

puts input.length