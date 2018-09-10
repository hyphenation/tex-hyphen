#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative 'languages.rb'

$path_root=File.expand_path("../../../..", __FILE__)
$path_plain="#{$path_root}/tex/generic/hyph-utf8/patterns/txt"
$path_quote="#{$path_root}/tex/generic/hyph-utf8/patterns/quote"

# TODO: should be singleton
$l = Languages.new

codes_to_skip = ['mn-cyrl-x-lmc']

$l.list.sort{|x,y| x.code <=> y.code }.each do |language|
	code = language.code

	if language.use_old_loader || codes_to_skip.include?(code)
		puts "(skipping #{language.code})"
		next
	end

	puts "generating #{code}"

	$file_pat = File.open("#{$path_plain}/hyph-#{code}.pat.txt", 'w')
	$file_hyp = File.open("#{$path_plain}/hyph-#{code}.hyp.txt", 'w')
	$file_let = File.open("#{$path_plain}/hyph-#{code}.chr.txt", 'w')
	$file_inf = File.open("#{$path_plain}/hyph-#{code}.lic.txt", 'w')

	patterns   = language.get_patterns
	exceptions = language.get_exceptions
	patterns_quote = Array.new

	patterns = $l['no'].get_patterns if code == 'nn' or code == 'nb'

	# patterns
	patterns.each do |pattern|
		$file_pat.puts pattern
		if pattern =~ /'/ then
			if code != "grc" and code != "el-monoton" and code != "el-polyton" then
				pattern_with_quote = pattern.gsub(/'/,"’")
				$file_pat.puts pattern_with_quote
				patterns_quote.push(pattern_with_quote)
			end
		end
	end

	# exceptions
	if exceptions != ""
		$file_hyp.puts exceptions
	end

	# letters
	characters_indexes = patterns.join('').gsub(/[.0-9]/,'').unpack('U*').sort.uniq
	characters_indexes.each do |c|
		ch = [c].pack('U')
		$file_let.puts ch + Unicode.upcase(ch)
		if ch == "'" and code != "grc" and code != "el-monoton" and code != "el-polyton" then
			$file_let.puts "’’"
		end
	end
	$file_inf.puts language.get_comments_and_licence

	$file_pat.close
	$file_hyp.close
	$file_let.close
	$file_inf.close

	if patterns_quote.length > 0
		f = File.open("#{$path_quote}/hyph-quote-#{code}.tex", 'w')
		f.puts "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{\n#{patterns_quote.join("\n")}\n}\n\\egroup\n"
		f.close
	end
end
