#!/usr/bin/env ruby

# This file generates patterns for Hyphenator.js
#     http://code.google.com/p/hyphenator
#
# Collaboration with:
#     Mathias Nater, <mathias at mnn.ch>

$path_root=File.expand_path(Dir.getwd + "/../../../hyph-utf8")
$path_sources="#{$path_root}/source/generic/hyph-utf8"
$path_plain="#{$path_root}/tex/generic/hyph-utf8/patterns/txt"
$path_repository=File.expand_path(Dir.getwd + "/../../collaboration/hyphenator")
$path_js=File.expand_path(Dir.getwd + "/../../repository/hyphenator")

load "#{$path_sources}/languages.rb"
# TODO: should be singleton
languages = Languages.new

languages["sr-latn"] = languages["sh-latn"]

# change to current folder and read all the files in it
Dir.chdir("#{$path_plain}")
files = Dir.glob("*.pat.txt")
# files = Dir.glob("*sl.pat.txt")

# we need to escape some characters; for a complete list see
#     http://www.jslint.com/lint.html
# but at the moment there are only two such characters present anyway
#
# this function encapsulates the string into single quotes and uses
def unescape_string_if_needed(str)
	# unsafe characters - see above for complete list
	unsafeCharacters = [0x200c, 0x200d]
	# let's convert our string into array (to preserve proper unicode numbers)
	str_array=str.unpack("U*")
	# set this to false until the first replacement takes place
	replacement_done = false

	# loop over all unsafe character and try to replace all occurencies
	unsafeCharacters.each do |c|
		# find the first occurence of that character
		i = str_array.index(c)
		while i != nil
			# replaces a single character with '%uXXXX', where XXXX is hex code of character
			# this only works with non-math characters, but it should not happen that any bigger number would occur
			str_array[i,1] = sprintf("%%u%4X", c).unpack("U*")
			i = str_array.index(c)
			replacement_done = true
		end
	end

	# convert the array back to string
	str = str_array.pack("U*")

	if replacement_done
		return "unescape('#{str}')"
	else
		return "'#{str}'"
	end
end

class Pattern
	# include Enumerable

	def initialize(pattern)
		@pattern = pattern.strip
		@pattern_array = @pattern.unpack("U*")
		@length = @pattern_array.length
	end

	def <=>(anOther)
		# if @length == anOther.length
		# 	0.upto(@length-1) do |i|
		# 		if @pattern_array[i] != anOther.pattern_array[i]
		# 			return @pattern_array[i] <=> anOther.pattern_array[i]
		# 		end
		# 	end
		# 	return 1 <=> 1
		# else
		# 	@length <=> anOther.length
		# end
		@length <=> anOther.length
	end

	def js_pattern
		@pattern.gsub(/[.]/, "_")
	end

	def to_s
		@pattern
	end
	
	def length_of_letters_only
		return @pattern.gsub(/[0-9]/,'').unpack("U*").length
	end

	# def sort_by_length
	attr_reader :pattern, :length, :pattern_array
end

# TODO: this should be an explicit array of patterns only
class Patterns < Array
	def length_of_shortest_and_longest_pattern
		# store the minimum and maximum length of pattern
		a = [self.first.length_of_letters_only, self.first.length_of_letters_only]
		#
		# a = [0, 1]
		self.each do |pat|
			a[0] = [a[0], pat.length_of_letters_only].min
			a[1] = [a[1], pat.length_of_letters_only].max
			# a.first = [a.first, pat.length_of_letters_only].min
			# a.last  = [a.last,  pat.length_of_letters_only].max
		end
		return a
	end
	# TODO: you need to make sure that patterns are sorted according to their length first
	def each_length
		current_length = 0
		first_pattern_with_some_size = Array.new

		self.each_index do |i|
			pattern = self[i]
			if pattern.length > current_length
				current_length = pattern.length
				first_pattern_with_some_size.push(i)
			end
		end

		first_pattern_with_some_size.each_index do |i|
			i_first = first_pattern_with_some_size[i]
			i_last = nil
			if i < first_pattern_with_some_size.length-1
				i_last = first_pattern_with_some_size[i+1]
			else
				i_last = self.length
			end
			i_len = i_last-i_first

			yield self[i_first,i_len]
		end
	end
end

files.each do |filename|
	code_in  = filename.gsub(/hyph-(.*).pat.txt/,'\1')
	code_out = code_in.gsub(/-/,"_")
	language = languages[code_in] # FIXME
	# TODO: handle exceptions
	puts
	puts "Generating Hyphenator.js support for " + code_in
	puts "    writing to '#{$path_js}/#{code_out}.js'"
	puts
	patterns = Patterns.new
	File.open(filename,'r') do |f_in|
		f_in.each_line do |line|
			if line.strip.length > 0
				patterns.push(Pattern.new(line))
			end
		end
	end
	patterns.sort!
	# puts patterns
	specialChars = patterns.join('').gsub(/[.0-9a-z]/,'').unpack('U*').sort.uniq.pack('U*')
	
	File.open("#{$path_js}/#{code_out}.js", "w") do |f_out|
		# BOM mark
		# f_out.puts [239,187,191].pack("ccc")
		# f_out.print ["EF","BB","BF"].pack("H2H2H2")
		f_out.putc(239)
		f_out.putc(187)
		f_out.putc(191)
		f_out.puts "Hyphenator.languages.#{code_out} = {"
		f_out.puts "\tleftmin : #{language.hyphenmin[0]},"
		f_out.puts "\trightmin : #{language.hyphenmin[1]},"
		lengths = patterns.length_of_shortest_and_longest_pattern
		f_out.puts "\tshortestPattern : #{lengths.first},"
		f_out.puts "\tlongestPattern : #{lengths.last},"
		# TODO: handle Ux201C, Ux201D
		# if specialChars.gsub!(/.../, ...) ~= nil
		# if specialChars =~ /[]/
		# if has_unsafe_characters(specialChars)
		# end
		unescape_string_if_needed(specialChars)
		f_out.puts "\tspecialChars : #{unescape_string_if_needed(specialChars)},"
		f_out.puts "\tpatterns : {"

		# current length of patterns (they are sorted according to their length)
		current_length = 0
		pattern_string = ""
		i_first = i_last = -1
		patterns.each_length do |pats|
			f_out.puts "\t\t#{pats.first.length} : #{unescape_string_if_needed(pats.join(""))}"
		end

		f_out.puts "\t}"
		f_out.puts "};"
	end
end
