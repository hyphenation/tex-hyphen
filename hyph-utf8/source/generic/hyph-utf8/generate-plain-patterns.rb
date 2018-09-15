#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative 'languages.rb'

$path_root=File.expand_path("../../../..", __FILE__)
$path_plain="#{$path_root}/tex/generic/hyph-utf8/patterns/txt"

Language.all.sort.each do |language|
	code = language.code

	if language.use_old_loader || code == 'mn-cyrl-x-lmc'
		puts "(skipping #{language.code})"
		next
	end

	puts "generating #{code}"

	files = Hash.new
	[:pat, :hyp, :chr, :lic].each do |ext|
		files[ext] = File.open File.join(PATH::TXT, sprintf('hyph-%s.%s', code, ext)), 'w'
	end

	patterns   = language.get_patterns
	exceptions = language.get_exceptions
	patterns_quote = Array.new

	# patterns
	patterns.each do |pattern|
		files[:pat].puts pattern
		if pattern =~ /'/ then
			if !language.isgreek?
				pattern_with_quote = pattern.gsub(/'/,"’")
				files[:pat].puts pattern_with_quote
				patterns_quote.push(pattern_with_quote)
			end
		end
	end

	# exceptions
	files[:hyp].puts exceptions if exceptions != ""

	# letters
	characters_indexes = patterns.join('').gsub(/[.0-9]/,'').unpack('U*').sort.uniq
	characters_indexes.each do |c|
		ch = [c].pack('U')
		files[:chr].puts ch + Unicode.upcase(ch)
		files[:chr].puts "’’" if ch == "'" && !language.isgreek?
	end
	files[:lic].puts language.get_comments_and_licence

	files.values.each do |file|
	  file.close
	end

	if patterns_quote.length > 0
		f = File.open File.join(PATH::QUOTE, sprintf('hyph-quote-%s.tex', code)), 'w'
		f.printf "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{\n"
		patterns_quote.each do |pattern|
			f.printf "%s\n", pattern
		end
		f.puts "}\n\\egroup\n"
		f.close
	end
end
