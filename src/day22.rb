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

file_path = ARGV[0]
file = File.open(file_path, 'r')

puts file.map(&:to_i).map(&method(:evolve)).sum
