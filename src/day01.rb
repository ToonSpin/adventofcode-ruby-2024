file_path = ARGV[0]
file = File.open(file_path, "r")

left = []
right = []
for line in file
    l, r = line.strip.split(/\s+/)
    left << l.to_i
    right << r.to_i
end

puts left.sort.zip(right.sort).map{ |a, b| (b - a).abs }.sum

counts = {}
for n in right
    if !counts.include?(n)
        counts[n] = 0
    end
    counts[n] += 1
end
for n in left
    if !counts.include?(n)
        counts[n] = 0
    end
end

similarity_score = 0
left.each do |n|
    similarity_score += n * counts[n]
end
puts similarity_score
