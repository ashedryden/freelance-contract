#!/usr/bin/env ruby
#/ Usage: ruby generate.rb input.md > output.md
#/ Replaces fields in the contract template

# show usage
if ARGV.empty? || ARGV.first == "--help"
  File.readlines(__FILE__).grep(/^#\//).map do |line|
    print line[3..-1]
  end
  exit 2
end

content = File.read(ARGV.shift)

$stderr.puts "Enter in replacement strings for each of the fields. "
$stderr.puts "You can keep a field in the file by just not entering a replacement. "

replacements = {}
content.scan(/\[[^\]]+\]/).uniq.each do |pattern|
  $stderr.print "Enter a value for #{pattern}: "
  replacements[pattern] = $stdin.gets.chomp
end

max = replacements.keys.map(&:size).max

replacements.each do |pattern,replacement|
  if replacement.empty?
    $stderr.puts "%#{max}s ignored" % [pattern]
  else
    $stderr.puts "%#{max}s -> %s" % [pattern, replacement]
    content.gsub!(pattern, replacement)
  end
end

$stderr.puts "-" * 80
$stderr.puts
puts content
