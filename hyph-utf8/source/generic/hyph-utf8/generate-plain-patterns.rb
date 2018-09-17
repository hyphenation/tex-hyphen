#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative 'languages.rb'
include Language::TeXLive

# FIXME sr-cyrl?
Language.all.sort.each do |language|
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
	file = outfile.call('pat')
	patterns[:plain].each do |pattern|
		file.puts pattern
	end

	# apostrophes if applicable
	with_apostrophe = patterns[:with_apostrophe]
	if with_apostrophe
		patterns = Array.new
		patterns << "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{"
		with_apostrophe.each do |pattern|
			patterns << sprintf("%s", pattern)
		end
		patterns << "}\n\\egroup"

		file = File.open File.join(PATH::QUOTE, sprintf('hyph-quote-%s.tex', code)), 'w'
		patterns.each do |pattern|
		  file.puts pattern
		end
	end

	# exceptions
	file = outfile.call('hyp') # This ensure a file is created, even if it may be empty
	if language.get_exceptions != ""
		file.puts language.get_exceptions
	end

	# characters
	file = outfile.call('chr')
	language.extract_characters.each do |character|
		file.puts character
	end

	# comments and licence
	file = outfile.call('lic')
	file.puts language.get_comments_and_licence

	file.close
end
