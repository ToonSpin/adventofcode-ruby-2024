class Robot
  attr_reader :p

  def initialize(line)
    line.match /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/
    @p = [$1.to_i, $2.to_i]
    @v = [$3.to_i, $4.to_i]
  end

  def iterate!(count, width, height)
    p, q = @p
    v, w = @v
    p = (p + v * count) % width
    q = (q + w * count) % height
    @p = [p, q]
  end

  def to_s()
    "<#{@p[0]}, #{@p[1]}>"
  end
end

class Area
  def initialize(robots, width, height)
    @robots = robots
    @width = width
    @height = height
  end

  def iterate(count)
    @robots.map {|r| r.iterate!(count, @width, @height)}
  end

  def safety()
    quadrant_width = @width / 2
    quadrant_height = @height / 2
    quadrant_positions = [
      [0, 0],
      [@width - quadrant_width, 0],
      [0, @height - quadrant_height],
      [@width - quadrant_width, @height - quadrant_height],
    ]

    safety_factor = 1
    quadrant_positions.each do |p, q|
      r = p + quadrant_width
      s = q + quadrant_height
      safety_factor *= @robots.map {|r| r.p}.filter {
        |x, y| x >= p && x < r && y >= q && y < s
      }.length
    end
    safety_factor
  end

  def to_s
    (0...@height).each do |y|
      line = @positions.filter {|p, q| q == y}
      x = 0
      line.sort!.each do |p, _|
        while x < p
          print '.'
          x += 1
        end
        print '#'
        x += 1
      end
      while x < @width
        print '.'
        x += 1
      end
      print "\n"
    end
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")

robots = file.map {|line| Robot.new line}
area = Area.new(robots, 101, 103)
area.iterate(100)
puts area.safety()

(100..).each do |i|
  if area.safety() < 50000000
    puts i
    break
  end
  area.iterate(1)
end
