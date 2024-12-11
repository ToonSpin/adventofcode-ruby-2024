require_relative "grid"

class Trailhead
  attr_accessor :cursors

  def initialize(x, y, grid)
    @cursors = [[x, y, 0]].to_set
    @grid = grid
  end

  def iterate()
    new_cursors = []
    @cursors.each do |x, y, h|
      @grid.neighbors(x, y, diag=false).each do |p, q|
        h_other = @grid.get_cell(p, q).to_i
        new_cursors.push [p, q, h_other] if h_other - h == 1
      end
    end
    @cursors = new_cursors.to_set
  end

  def to_s()
    th = @cursors.map {|x, y, h| "(#{x}, #{y}, #{h})"}.join ", "
    "[#{th}]"
  end

  def score
    @cursors.length
  end
end

class TopographicMap < Grid
  def initialize(content)
    super content
    @trailheads = []
    self.scan('0') do |x, y, c|
      h = c.to_i
      @trailheads << Trailhead.new(x, y, self)
    end
  end

  def iterate
    @trailheads.each { |t| t.iterate }
  end

  def score
    @trailheads.map { |t| t.score }.sum
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")
grid = TopographicMap.new(file.read)

(0...9).each { grid.iterate }
puts grid.score
