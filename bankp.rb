txts = Dir.glob("*.txt")
$fh = File.open("./insx.txt", "w")
for i in 0 .. (txts.length-1)
	data = File.read(txts[i])
	$fh.puts data
end

$fh.close()

puts "working"
File.write("./insx.txt", File.read("./insx.txt").gsub(/\n+/, "\n").strip)