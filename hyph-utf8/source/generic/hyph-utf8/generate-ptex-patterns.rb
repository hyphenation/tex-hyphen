#!/usr/bin/env ruby

require 'hyph-utf8'

# this file generates patterns for pTeX out of the plain ones

# use 'gem install unicode' if unicode is missing on your computer
# require 'jcode'
# require 'rubygems'
# require 'unicode'

load 'languages.rb'

$path_root=File.expand_path("../../..")
$path_ptex="#{$path_root}/tex/generic/hyph-utf8/patterns/ptex"

# load encodings
encodings_list = ["ascii", "ec", "qx", "t2a", "lmc", "il2", "il3", "l7x"]
encodings = Hash.new
encodings_list.each do |encoding_name|
	encodings[encoding_name] = Encoding.new(encoding_name)
end

$l = Languages.new

# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

language_codes = Hash.new
languages.each do |language|
	language_codes[language.code] = language.code
end
# language_codes['mn-cyrl-x-lmc'] = nil
# language_codes['sh-latn']       = 'sr-latn'
# language_codes['sh-cyrl']       = nil

# e = Encoding.new("ec")
# puts e.convert_string_to_escaped_characters("moja čaša")
# 
# return

languages.sort{|x,y| x.code <=> y.code }.each do |language|
	encoding = nil
	if language.use_new_loader then
		if language.encoding == nil or language_codes[language.code] == nil
			include_language = false
			puts "(skipping #{language.code} # encoding)"
		elsif language.encoding == 'ascii'
			include_language = false
			puts "(skipping #{language.code} # ascii)"
		else
			include_language = true
			encoding = encodings[language.encoding]
		end
	else
		include_language = false
		puts "(skipping #{language.code} # loader)"
	end

	code = language_codes[language.code]

	if include_language
		puts ">> generating #{code} (#{language.name})"
		file_ptex = File.open("#{$path_ptex}/hyph-#{code}.#{language.encoding}.tex", "w")

		patterns   = language.get_patterns
		exceptions = language.get_exceptions

		if code == 'nn' or code == 'nb'
			patterns = $l['no'].get_patterns
		end

		if language.encoding != 'ascii' then
			patterns   = encoding.convert_to_escaped_characters(patterns)
			exceptions = encoding.convert_to_escaped_characters(exceptions)
		end

		file_ptex.puts("% pTeX-friendly hyphenation patterns")
		file_ptex.puts("%")
		file_ptex.puts("% language: #{language.name} (#{language.code})")
		file_ptex.puts("% encoding: #{language.encoding}")
		file_ptex.puts("%")
		file_ptex.puts("% This file has been auto-generated from hyph-#{language.code}.tex")
		file_ptex.puts("% with a script [texmf]/scripts/generic/hyph-utf8/generate-ptex-patterns.rb")
		file_ptex.puts("% See the original file for details about author, licence etc.")
		file_ptex.puts("%")

		if patterns.length > 0 then
			# file_ptex.puts("\\patterns{\n#{encoding.convert_to_escaped_characters(patterns.join("\n"))}\n}")
			file_ptex.puts("\\patterns{\n#{patterns.join("\n")}\n}")
		end
		if exceptions.length > 0 then
			# file_ptex.puts("\\hyphenation{\n#{encoding.convert_to_escaped_characters(exceptions.join("\n"))}\n}")
			file_ptex.puts("\\hyphenation{\n#{exceptions.join("\n")}\n}")
		end


	# 	# patterns
	# 	patterns.each do |pattern|
	# 		$file_pat.puts pattern.gsub(/'/,"’")
	# 	end
	# 	# exceptions
	# 	if exceptions != ""
	# 		$file_hyp.puts exceptions
	# 	end
		file_ptex.close
	end
end
