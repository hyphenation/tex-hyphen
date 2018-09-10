#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), 'hyph-utf8'))

# this file generates patterns for pTeX out of the plain ones

# use 'gem install unicode' if unicode is missing on your computer
# require 'jcode'
# require 'rubygems'
# require 'unicode'

require_relative 'languages.rb'

$path_root=File.expand_path("../../../..", __FILE__)
$path_ptex="#{$path_root}/tex/generic/hyph-utf8/patterns/ptex"

# load encodings
encodings_list = ["ascii", "ec", "qx", "t2a", "lmc", "il2", "il3", "l7x", "t8m", "lth"]
encodings = Hash.new
encodings_list.each do |encoding_name|
	encodings[encoding_name] = HyphEncoding.new(encoding_name)
end

header = <<-HEADER
%% pTeX-friendly hyphenation patterns
%%
%% language: %s (%s)
%% encoding: %s
%%
%% This file has been auto-generated from hyph-%s.tex
%% with a script [texmf]/scripts/generic/hyph-utf8/generate-ptex-patterns.rb
%% See the original file for details about author, licence etc.
%%
HEADER

$l = Languages.new

# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

languages.sort { |x,y| x.code <=> y.code }.each do |language|
	if language.use_old_loader
		puts "(skipping #{language.code} # loader)"
		next
	end

	if language.encoding == nil || language.encoding == 'ascii'
		puts "(skipping #{language.code} # #{if language.encoding then 'ascii' else 'encoding' end})"
		next
	else
		encoding = encodings[language.encoding]
	end

	code = language.code

	puts ">> generating #{code} (#{language.name})"
	File.open("#{$path_ptex}/hyph-#{code}.#{language.encoding}.tex", "w") do |file_ptex|

		patterns   = language.get_patterns
		exceptions = language.get_exceptions

		if code == 'nn' or code == 'nb'
			patterns = $l['no'].get_patterns
		end

		characters = patterns.join('').gsub(/[.0-9]/,'').unpack('U*').sort.uniq

		if language.encoding != 'ascii' then
			patterns   = encoding.convert_to_escaped_characters(patterns)
			exceptions = encoding.convert_to_escaped_characters(exceptions)
		end

		file_ptex.printf(header, language.name, language.code, language.encoding, language.code)

		file_ptex.puts("\\bgroup")
		# setting lccodes for letters
		characters.each do |c|
			if (c == 0x01FD or c == 0x0301) and language.code == 'la-x-liturgic'
				# skip
			elsif c >= 128 then
				code = encoding.unicode_characters[c].code_enc
				file_ptex.printf("\\lccode\"%02X=\"%02X\n", code, code)
			end
		end
		# patterns
		if patterns.length > 0 then
			file_ptex.puts("\\patterns{\n#{patterns.join("\n")}\n}")
		end
		# exceptions
		if exceptions.length > 0 then
			file_ptex.puts("\\hyphenation{\n#{exceptions.join("\n")}\n}")
		end
		file_ptex.puts("\\egroup")
	end
end
