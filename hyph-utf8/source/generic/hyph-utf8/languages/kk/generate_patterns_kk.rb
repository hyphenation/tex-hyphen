#!/usr/bin/env ruby
#
# This script generates hyphenation patterns for Turkmen
#
# This script has been modified from a script by Mojca Miklavec <mojca dot miklavec dot lists at gmail dot com>
# Copyright (C) Mojca Miklavec 2010, Robert Ermers 2025, Arthur Rosendahl 2026
# MIT licence (https://opensource.org/license/MIT)

# open file for writing the patterns
# in TDS
# $tr = File.new("hyph-kk.tex", "w")
$tr = File.new(File.expand_path("../../../../../tex/generic/hyph-utf8/patterns/tex/hyph-kk.tex", __dir__), "w")

# write comments into the file
def add_comment(str)
	$tr.puts "% " + str.gsub(/\n/, "\n% ").gsub(/% \n/, "%\n")
end

# define a class of vowels and consonants
# vowels are split into so that unnecessary permutations are not generated
vowels = %w{а о ұ ы у ю я е ә і ү ө ё}
# back_vowels = %w{я а о ұ ы}
# front_vowels = %w{е ә і ү ө э}
# front_vowels = %w{ä e i ö ü}
# back_vowels = %w{a y o u}
consonants = %w{б в г ғ д ж з һ к қ п с т ф х ц ч ш щ й л м н ң р у}
# This is to eliminate impossible combinations
common_suffix_consonants = %w{д т у с к қ г ғ л б м п ш}
# common_suffix_consonants = %w{ш ç d g j k l m n p s t ý z ş}


# In Kazakh there are: 7 sonorants: й, л, м, н, ң, р, у 
# 8 voiced consonants: б, в,г, ғ, д, ж, з, һ 
# 11 unvoiced consonants: к, қ, п, с, т, ф, х, ц, ч, ш, щ

# А а	Ә ә	Б б	В в	Г г	Ғ ғ	Д д
# Е е	Ё ё	Ж ж	З з	И и	Й й	К к
# Қ қ	Л л	М м	Н н	Ң ң	О о	Ө ө
# П п	Р р	С с	Т т	У у	Ұ ұ	Ү ү
# Ф ф	Х х	Һ һ	Ц ц	Ч ч	Ш ш	Щ щ
# Ъ ъ	Ы ы	І і	Ь ь	Э э	Ю ю	Я я


# start the file
add_comment(
"title: Hyphenation patterns for Kazakh (hyph-kk.tex)
copyright: Copyright (C) 2010 Mojca Miklavec, 2025 Robert Ermers, 2026 Arthur Rosendahl
notice: This file is part of the hyph-utf8 package.
    See https://www.hyphenation.org/tex for more information
authors:
  - name: Mojca Miklavec
  - name: Robert Ermers
  - name: Arthur Rosendahl
language:
    name: Kazakh
    tag: kk
licence:
    name: Public domain
version: 0.1 Date 7 june 2025
texlive:
    encoding: t2a
    babelname: kazakh
    message: Kazkakh hyphenation patterns
    description: Hyphenation patterns for Kazakh in T2A and UTF-8 encodings.
hyphenmins:
    typesetting:
        left: 2
        right: 2

==========================================

The file has been auto-generated from generate_patterns_kk.rb
that is part of hyph-utf8.

For more information about UTF-8 hyphenation patterns for TeX and
links to this file see
    http://www.tug.org/tex-hyphen/
")

# we have the following comment for Kazakh:
#
# Some of the patterns below represent combinations that never
# happen in Turkmen. Would they happen, they would be hyphenated
# according to the rules.

$tr.puts '\patterns{'
add_comment("Some suffixes are added through a hyphen. When hyphenating these words, a hyphen is added before the hyphen so that the line ends with a hyphen and the new line starts with a hyphen.")
$tr.puts "1-4"

add_comment("Allow hyphen after a vowel if and only if there is a single consonant before next the vowel")
# front_vowels.each do |v1|
# 	consonants.each do |c|
# 		front_vowels.each do |v2|
# 			$tr.puts "#{v1}1#{c}#{v2}"
# 		end
# 	end
# end

# back_vowels.each do |v1|
# 	consonants.each do |c|
# 		back_vowels.each do |v2|
# 			$tr.puts "#{v1}1#{c}#{v2}"
# 		end
# 	end
# end

vowels.each do |v1|
	consonants.each do |c|
		vowels.each do |v2|
			$tr.puts "#{v1}1#{c}#{v2}"
		end
	end
end

# add_comment("These combinations occur in words of foreign origin or joined words")
consonants.each do |c|
  	# $tr.puts "а1#{c}і"
  	# $tr.puts "a1#{c}e"
	# $tr.puts "y1#{c}ä"
	# $tr.puts "y1#{c}i"
	# $tr.puts "y1#{c}e"
	# $tr.puts "o1#{c}i"
	# $tr.puts "o1#{c}e"
	# $tr.puts "u1#{c}i"
	# $tr.puts "u1#{c}e"
	# $tr.puts "i1#{c}a"
	# $tr.puts "i1#{c}o"
	# $tr.puts "e1#{c}a"
	# $tr.puts "e1#{c}o"
	# $tr.puts "ä1#{c}o"
	# $tr.puts "ä1#{c}a"
	# $tr.puts "ö1#{c}a"
end

add_comment("Allow hyphen between two consonants (if there is only two of them), except when they are at the begining of the word")
consonants.each do |c1|
	consonants.each do |c2|
		$tr.puts "#{c1}1#{c2}"
		$tr.puts ".#{c1}2#{c2}"
	end
end

add_comment("Patterns for triple consonants. There may be additions to this category, as this list is not exhaustive.")
common_suffix_consonants.each do |c|
  next if c == 'у'
	$tr.puts "у2т1#{c}"
	# $tr.puts "ý2n1#{c}"
	# $tr.puts "ý2d1#{c}"
	# $tr.puts "r2t1#{c}"
	# $tr.puts "ý2p1#{c}"
	# $tr.puts "l2p1#{c}"
	# $tr.puts "l2t1#{c}"
	# $tr.puts "g2t1#{c}"
	# $tr.puts "n2t1#{c}"
	# $tr.puts "r2k1#{c}"
	# $tr.puts "r2p1#{c}"
	# $tr.puts "k2t1#{c}"
	# $tr.puts "r2h1#{c}"
	# $tr.puts "s2t1#{c}"
	# $tr.puts "l2k1#{c}"
	# $tr.puts "w2p1#{c}"
	# $tr.puts "n2s1#{c}"
	# $tr.puts "r2s1#{c}"
	# $tr.puts "l2m1#{c}"
end

add_comment("Exceptions and single word occurence patterns for words of foreign origin i.e. Russian")
$tr.puts "с2к1д"
$tr.puts "л1с2к"
$tr.puts "л1с2т"
$tr.puts "с1т2р"
$tr.puts "н2г1л"
$tr.puts "н1г2р"
$tr.puts "с2к1у" # AR 2026-02-21 Was s2k1w, I had to improvise

# end the file
$tr.puts '}'
$tr.close

