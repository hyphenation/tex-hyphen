#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative '../../../../lib/tex/hyphen/language.rb'
include OldLanguage::TeXLive

# FIXME sr-cyrl?
OldLanguage.all.sort.each do |language|
	code = language.code

	if language.use_old_loader || code == 'mn-cyrl-x-lmc'
		puts "(skipping #{language.code})"
		next
	end

	puts "generating #{code}"

	outfile = Proc.new do |ext|
		File.open File.join(PATH::TXT, sprintf('hyph-%s.%s.txt', code, ext)), 'w'
	end

	# patterns
	patterns = language.extract_apostrophes
	file = outfile.('pat')
	patterns[:plain].each do |pattern|
		file.puts pattern
	end

	# apostrophes if applicable
	with_apostrophe = patterns[:with_apostrophe]
	if with_apostrophe
		file = File.open File.join(PATH::QUOTE, sprintf('hyph-quote-%s.tex', code)), 'w'
		file.printf "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{\n"
		with_apostrophe.each do |pattern|
			file.printf "%s\n", pattern
		end
		file.puts "}\n\\egroup\n"
	end

	# exceptions
	file = outfile.('hyp') # This ensure a file is created, even if it may be empty
	file.puts language.exceptions if language.exceptions != ""

	# characters
	file = outfile.('chr')
	language.extract_characters.each do |character|
		file.puts character
	end

	# comments and licence
	file = outfile.('lic')
	file.puts language.get_comments_and_licence

	file.close
end
