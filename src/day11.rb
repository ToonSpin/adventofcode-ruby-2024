file_path = ARGV[0]
file = File.open(file_path, "r")

$stone_counts = {}

def get_stone_count_single(stone)
  return 1 if stone == 0
  num_digits = Math.log10(stone).floor + 1
  return 2 if num_digits % 2 == 0
  return 1
end

def get_stone_count(stone, iterations)
  key = [stone, iterations]

  if !$stone_counts.include?(key)
    if iterations == 1
      $stone_counts[key] = get_stone_count_single(stone)
      return $stone_counts[key]
    end

    if stone == 0
      $stone_counts[key] = get_stone_count(1, iterations - 1)
    else
      num_digits = Math.log10(stone).floor + 1
      if num_digits % 2 == 0
        factor = 10 ** (num_digits / 2)
        $stone_counts[key] = get_stone_count((stone / factor).floor, iterations - 1)
        $stone_counts[key] += get_stone_count(stone % factor, iterations - 1)
      else
        $stone_counts[key] = get_stone_count(stone * 2024, iterations - 1)
      end
    end
  end

  return $stone_counts[key]
end

input = file.read.strip.split.map {|s| s.to_i}

count = input.map { |stone| get_stone_count(stone, 25) }
puts count.sum

count = input.map { |stone| get_stone_count(stone, 75) }
puts count.sum
