require 'strscan'

class Grid
  def initialize(content)
    @lines = content.split "\n"
    @width = @lines[0].length
    @height = @lines.length
  end

  def scan(regex_or_string)
    result = []
    if regex_or_string.is_a? String
      regex_or_string = /#{Regexp.quote(regex_or_string)}/
    end
    @lines.each_with_index do |line, y|
      s = StringScanner.new(line)
      while s.skip_until(regex_or_string)
        x = s.pos - s.matched_size
        if block_given?
          yield([x, y, line.slice(x, s.matched_size)])
        else
          result.push [x, y, line.slice(x, s.matched_size)]
        end
      end
    end
    return result if not block_given?
  end

  def neighbors(x, y, diag=true)
    result = []
    for q in (y-1..y+1)
      for p in (x-1..x+1)
        next if p < 0
        next if q < 0
        next if p >= @width
        next if q >= @height
        next if !diag && p != x && q != y
        if block_given?
          yield(x, y)
        else
          result << [p, q]
        end
      end
    end
    return result if not block_given?
  end

  def get_cell(x, y)
    @lines[y][x]
  end

  def to_s()
    @lines.join "\n"
  end

  def in_bounds?(x, y)
    return false if x < 0
    return false if y < 0
    return false if x >= @width
    return false if y >= @height
    return true
  end
end
