#!/usr/bin/env ruby
#
# This script generates hyphenation patterns for Turkmen
#

# open file for writing the patterns
# $tr = File.new("hyph-tk.tex", "w")
# in TDS
$tr = File.new("../../../../../tex/generic/hyph-utf8/patterns/hyph-tk.tex", "w")

# write comments into the file
def add_comment(str)
	$tr.puts "% " + str.gsub(/\n/, "\n% ").gsub(/% \n/, "%\n")
end

# define a class of vowels and consonants
vowels = %w{a â e ı i î o ö u ü û}
consonants = %w{b c ç d f g ğ h j k l m n p r s ş t v y z}

v1 = %w{ä e i ö ü}
v2 = %w{a y o u}
c1 = %w{b ç d f g h j k l m n p r s t w ý z ň ž ş}


# start the file
add_comment(
"hyph-tk.tex

File auto-generated from generate_patterns_tk.rb that is part of hyph-utf8

Author: Nazar Annagurban <nazartm at gmail.com>

For more information about the new UTF-8 hyphenation patterns and
links to this file see
    http://www.tug.org/tex-hyphen/

Some of the patterns below represent combinations that never
happen in Turkmen. Would they happen, they would be hyphenated
according to the rules.
")

$tr.puts '\patterns{'
$tr.puts "1-4"

v1.each do |v1_1|
	c1.each do |c1_1|
		v1.each do |v1_2|
			$tr.puts "#{v1_1}1#{c1_1}#{v1_2}"
		end
	end
end

v2.each do |v2_1|
	c1.each do |c1_1|
		v2.each do |v2_2|
			$tr.puts "#{v2_1}1#{c1_1}#{v2_2}"
		end
	end
end

c1.each do |c1_1|
	$tr.puts "i1#{c1_1}a"
	$tr.puts "i1#{c1_1}o"
	$tr.puts "a1#{c1_1}i"
	$tr.puts "e1#{c1_1}a"
	$tr.puts "e1#{c1_1}o"
	$tr.puts "a1#{c1_1}e"
	$tr.puts "ä1#{c1_1}o"
	$tr.puts "ä1#{c1_1}a"
	$tr.puts "y1#{c1_1}i"
	$tr.puts "y1#{c1_1}e"
	$tr.puts "ö1#{c1_1}a"
	$tr.puts "u1#{c1_1}e"
	$tr.puts "o1#{c1_1}i"
	$tr.puts "y1#{c1_1}ä"
	$tr.puts "o1#{c1_1}e"
	$tr.puts "u1#{c1_1}i"
end

c1.each do |c1_1|
	c1.each do |c1_2|
		$tr.puts "#{c1_1}1#{c1_2}"
		$tr.puts ".#{c1_1}2#{c1_2}"
	end
end

c1.each do |c1_1|
	$tr.puts "ý2t1#{c1_1}"
	$tr.puts "ý2n1#{c1_1}"
	$tr.puts "ý2d1#{c1_1}"
	$tr.puts "r2t1#{c1_1}"
	$tr.puts "ý2p1#{c1_1}"
	$tr.puts "l2p1#{c1_1}"
	$tr.puts "l2t1#{c1_1}"
	$tr.puts "g2t1#{c1_1}"
	$tr.puts "n2t1#{c1_1}"
	$tr.puts "r2k1#{c1_1}"
	$tr.puts "r2p1#{c1_1}"
	$tr.puts "k2t1#{c1_1}"
	$tr.puts "r2h1#{c1_1}"
	$tr.puts "s2t1#{c1_1}"
	$tr.puts "l2k1#{c1_1}"
	$tr.puts "w2p1#{c1_1}"
	$tr.puts "n2s1#{c1_1}"
	$tr.puts "r2s1#{c1_1}"
	$tr.puts "l2m1#{c1_1}"
end

#$tr.puts "r1t2r"
#$tr.puts "n2s1p"
$tr.puts "s2k1d"
$tr.puts "t2r1d"
#$tr.puts "k1t2r"
$tr.puts "l1s2k"
$tr.puts "l1s2t"
#$tr.puts "s1t2r"
$tr.puts "n2g1l"
$tr.puts "n1g2r"
$tr.puts "s2k1w"

# end the file
$tr.puts '}'
$tr.close
