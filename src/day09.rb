class Fragment
  attr_accessor :file_id
  attr_accessor :offset
  attr_accessor :size

  def initialize(file_id, offset, size)
    @file_id = file_id
    @offset = offset
    @size = size
  end

  def split_right(size)
    raise "Subfragment must be smaller than #{@size}" if size >= @size
    @size -= size
    return Fragment.new(@file_id, @offset + size, size)
  end

  def checksum()
    return self.file_id * (self.size * (self.offset + (self.offset + self.size - 1)) / 2)
  end
end

class DiskMap
  def initialize(input)
    @fragments = []
    offset = 0
    file_id = 0
    input.each_slice(2) do |file_length, empty_space|
      @fragments << Fragment.new(file_id, offset, file_length)
      offset += file_length + empty_space if !empty_space.nil?
      file_id += 1
    end
  end

  def move_file_blocks()
    fragment_index = 0
    while fragment_index < @fragments.length - 1
      cur_f, next_f = @fragments[fragment_index, 2]
      empty_space = next_f.offset - cur_f.offset - cur_f.size

      if empty_space == 0
        fragment_index += 1
        next
      end

      if empty_space < @fragments.last.size
        @fragments << @fragments.last.split_right(empty_space)
      end

      last_f = @fragments.pop
      last_f.offset = cur_f.offset + cur_f.size

      new_f = @fragments[0, fragment_index + 1]
      new_f << last_f
      new_f += @fragments[fragment_index + 1, @fragments.length]

      @fragments = new_f
    end
  end

  def checksum()
    @fragments.map { |f| f.checksum }.sum
  end

  def to_s()
    s = ''
    offset = 0
    @fragments.each do |f|
      while offset < f.offset
        s += '.'
        offset += 1
      end
      s += f.file_id.to_s * f.size
      offset += f.size
    end
    return s
  end
end

file_path = ARGV[0]
file = File.open(file_path, "r")

input = []
file.read().strip.each_char do |d|
  input << d.to_i
end

disk_map = DiskMap.new(input)
disk_map.move_file_blocks
puts disk_map.checksum

disk_map = DiskMap.new(input)
puts disk_map
disk_map.defragment
puts disk_map
puts disk_map.checksum
