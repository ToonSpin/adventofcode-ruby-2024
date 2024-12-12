require_relative "grid"

class Plot
  attr_accessor :area
  attr_accessor :edges
  attr_accessor :perimeter
  attr_accessor :symbol

  def price_part_one
    @area * @perimeter
  end

  def price_part_two
    @area * @edges
  end
end

class Garden < Grid
  def initialize(content)
    super content
  end

  def get_plots
    return @plots if !@plots.nil?
    @plots = []
    visited = [].to_set
    while visited.length < @width * @height
      @plots.push self.get_next_plot(visited)
    end
    @plots
  end

  private

  def next_plot_start(visited)
    self.each_cell do |x, y|
      return [x, y] if !visited.include? [x, y]
    end
  end

  def get_next_plot(visited)
    x, y = self.next_plot_start(visited)
    vertices = {}

    plot = Plot.new
    plot.symbol = self.get_cell x, y
    plot.area = 0
    plot.edges = 0
    plot.perimeter = 0

    queue = [[x, y]]
    while queue.length > 0
      x, y = queue.pop
      next if visited.include? [x, y]
      visited.add [x, y]
      
      (0..1).each do |p|
        (0..1).each do |q|
          v = [x+p, y+q]
          count, r, s = vertices.fetch(v, [0, 0, 0])
          vertices[v] = [count + 1, r + p, s + q]
        end
      end

      plot.area += 1
      plot.perimeter += 4
      for p, q in self.neighbors(x, y)
        if self.get_cell(p, q) == plot.symbol
          plot.perimeter -= 1
          queue.push [p, q] if !visited.include? [p, q]
        end
      end
    end

    vertices.each do |_, a|
      count, r, s = a
      plot.edges += 1 if count % 2 == 1
      plot.edges += 2 if count == 2 && (r == 1 && s == 1)
    end

    plot
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")
grid = Garden.new(file.read)

puts grid.get_plots.map {|p| p.price_part_one}.sum
puts grid.get_plots.map {|p| p.price_part_two}.sum
