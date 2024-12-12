require_relative 'grid'

class WordSearch < Grid
  def count_xmas
    count = 0
    self.scan('X').each do |x, y, _|
      (-1..1).each do |q|
        (-1..1).each do |p|
          next if p == 0 && q == 0
          found = 0
          'MAS'.split('').each_with_index do |c, i|
            r = x + (i + 1) * p
            s = y + (i + 1) * q
            break if !self.in_bounds?(r, s)
            break if self.get_cell(r, s) != c
            found += 1
          end
          count += 1 if found == 3
        end
      end
    end
    return count
  end

  def count_x_mas
    count = 0
    self.scan('A').each do |x, y, _|
      next if !self.in_bounds?(x - 1, y - 1)
      next if !self.in_bounds?(x + 1, y + 1)

      c1 = self.get_cell(x - 1, y - 1)
      c2 = self.get_cell(x + 1, y + 1)
      next if "#{c1}A#{c2}" != "MAS" && "#{c2}A#{c1}" != "MAS"

      c1 = self.get_cell(x + 1, y - 1)
      c2 = self.get_cell(x - 1, y + 1)

      count += 1 if "#{c1}A#{c2}" == "MAS" || "#{c2}A#{c1}" == "MAS"
    end
    return count
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")
grid = WordSearch.new file.read

puts grid.count_xmas
puts grid.count_x_mas
