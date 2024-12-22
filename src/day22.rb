# frozen_string_literal: true

def mix(secret, other)
  secret ^ other
end

def prune(secret)
  secret & 16_777_215
end

def evolve_once(secret)
  secret = prune(mix(secret, secret << 6))
  secret = prune(mix(secret, secret >> 5))
  prune(mix(secret, secret << 11))
end

def evolve(secret)
  2000.times { secret = evolve_once(secret) }
  secret
end

def get_index(changes)
  changes.inject { |a, e| (e + 9) + (19 * a) }
end

def get_map(secret)
  evolutions = [secret % 10]
  2000.times do
    secret = evolve_once(secret)
    evolutions << (secret % 10)
  end

  diffs = (1...evolutions.length).map { |i| evolutions[i] - evolutions[i - 1] }

  prices_map = {}
  (0..diffs.length - 4).each do |i|
    changes = get_index(diffs[i..i + 3])
    prices_map[changes] = evolutions[i + 4] unless prices_map.include? changes
  end

  prices_map
end

def get_winnings(maps, key)
  maps.map { |m| m[key] }.compact.sum
end

file_path = ARGV[0]
file = File.open(file_path, 'r')

secrets = file.map(&:to_i)
puts secrets.map(&method(:evolve)).sum

maps = secrets.map(&method(:get_map))
puts maps.map(&:keys).flatten.to_set.map { |k| get_winnings(maps, k) }.max
