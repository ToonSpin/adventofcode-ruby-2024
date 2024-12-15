require_relative "grid"

class Lab < Grid
  def initialize(content)
    super content
    @guard_x, @guard_y, _ = self.scan('^')[0]
    @guard_dir = :north
    @obstructions = self.scan('#')
    @visited = [].to_set
  end

  def trace_guard()
    while !@guard_dir.nil?
      self.iterate
    end
    return @visited
  end
  protected

  def next_ob_in_dir(x, y, dir)
    filtered = case dir
    in :north | :south
      self.obs_by_x(x)
    in :east | :west
      self.obs_by_y(y)
    end

    return case dir
    in :north
      filtered = filtered.filter { |p, q, _| q < y }
      filtered.min_by { |p, q, _| -q }
    in :east
      filtered = filtered.filter { |p, q, _| p > x }
      filtered.min_by { |p, q, _| p }
    in :south
      filtered = filtered.filter { |p, q, _| q > y }
      filtered.min_by { |p, q, _| q }
    in :west
      filtered = filtered.filter { |p, q, _| p < x }
      filtered.min_by { |p, q, _| -p }
    end
  end

  def turn(dir)
    return case dir
    in :north
      :east
    in :east
      :south
    in :south
      :west
    in :west
      :north
    end
  end

  def iterate()
    x, y, _ = self.next_ob_in_dir(@guard_x, @guard_y, @guard_dir)
    if x.nil?
      path = case @guard_dir
      in :north
        (@guard_y..0).step(-1).map {|y| [@guard_x, y]}.to_a
      in :east
        (@guard_x..@width-1).map {|x| [x, @guard_y]}.to_a
      in :south
        (@guard_y..@height-1).map {|y| [@guard_x, y]}.to_a
      in :west
        (@guard_x..0).step(-1).map {|x| [x, @guard_y]}.to_a
      end
      @guard_dir = nil
      @visited += path.to_set
    else
      path = case @guard_dir
      in :north
        (@guard_y..y+1).step(-1).map {|y| [@guard_x, y]}.to_a
      in :east
        (@guard_x..x-1).map {|x| [x, @guard_y]}.to_a
      in :south
        (@guard_y..y-1).map {|y| [@guard_x, y]}.to_a
      in :west
        (@guard_x..x+1).step(-1).map {|x| [x, @guard_y]}.to_a
      end
      @guard_x, @guard_y = path.last
      @visited += path.to_set
      @guard_dir = self.turn(@guard_dir)
    end
  end

  def obs_by_x(x)
    @obstructions.filter { |p, q, _| p == x }
  end

  def obs_by_y(y)
    @obstructions.filter { |p, q, _| y == q }
  end


end

file_path = ARGV[0]
file = File.open(file_path, "r")

lab = Lab.new file.read
puts lab.trace_guard.length

