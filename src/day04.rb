require_relative 'grid'

class WordSearch < Grid
  def mas_at?(x, y, p, q)
    found = 0
    'MAS'.chars.each_with_index do |c, i|
      r = x + ((i + 1) * p)
      s = y + ((i + 1) * q)

      break unless in_bounds?(r, s)
      break if get_cell(r, s) != c

      found += 1
    end
    found == 3
  end

  def count_mas_at(x, y)
    [-1, 0, 1].product([-1, 0, 1]).count { |p, q| mas_at?(x, y, p, q) }
  end

  def mas_x_at?(x, y)
    return false unless in_bounds?(x - 1, y - 1)
    return false unless in_bounds?(x + 1, y + 1)

    c1 = get_cell(x - 1, y - 1)
    c2 = get_cell(x + 1, y + 1)
    return false unless "#{c1}A#{c2}" == 'MAS' || "#{c2}A#{c1}" == 'MAS'

    c1 = get_cell(x + 1, y - 1)
    c2 = get_cell(x - 1, y + 1)
    "#{c1}A#{c2}" == 'MAS' || "#{c2}A#{c1}" == 'MAS'
  end

  def count_xmas
    scan('X').map { |x, y, _| count_mas_at(x, y) }.sum
  end

  def count_x_mas
    scan('A').count { |x, y,| mas_x_at? x, y }
  end
end

file_path = ARGV[0]
file = File.open(file_path, 'r')
grid = WordSearch.new file.read

puts grid.count_xmas
puts grid.count_x_mas
