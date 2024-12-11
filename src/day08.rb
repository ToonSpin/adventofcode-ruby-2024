require_relative "grid"

class Map < Grid
  def initialize(content)
    super content
    @antennae = self.scan(/[a-zA-Z0-9]/)
    @frequencies = @antennae.map { |p, q, f| f }.to_set
  end

  def get_antinodes(part_two = false)
    antinodes = []
    @frequencies.each do |frequency|
      coords = @antennae.filter { |p, q, f| f == frequency }
      coords.each_with_index do |a, i|
        coords[i+1,coords.length].each do |b|
          dx = b[0] - a[0]
          dy = b[1] - a[1]
          if part_two
            ranges = [(0..), (-1..).step(-1)]
          else
            ranges = [[-1], [2]]
          end
          ranges.each do |range|
            range.each do |i|
              x, y = a[0] + i * dx, a[1] + i * dy
              break if !self.in_bounds?(x, y)
              antinodes << [x, y]
            end
          end
        end
      end
    end
    return antinodes.to_set
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")
map = Map.new(file.read)

puts map.get_antinodes(part_two = false).length
puts map.get_antinodes(part_two = true).length
