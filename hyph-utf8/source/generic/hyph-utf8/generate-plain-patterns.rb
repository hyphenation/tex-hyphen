#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative 'languages.rb'
include Language::TeXLive

Language.all.sort.each do |language|
	code = language.code

	if language.use_old_loader || code == 'mn-cyrl-x-lmc'
		puts "(skipping #{language.code})"
		next
	end

	puts "generating #{code}"

	def outfile(ext)
		File.open File.join(PATH::TXT, sprintf('hyph-%s.%s.txt', code, ext)), 'w'
	end

	# patterns
	patterns = language.extract_apostrophes
	outfile('pat') do |file|
		patterns[:plain].each do |pattern|
		  file.puts pattern
		end
	end

  # apostrophes if applicable
	with_quote = patterns[:with_quote]
	if with_quote
		f = File.open File.join(PATH::QUOTE, sprintf('hyph-quote-%s.tex', code)), 'w'
		f.printf "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{\n"
		with_quote.each do |pattern|
			f.printf "%s\n", pattern
		end
		f.puts "}\n\\egroup\n"
		f.close
	end

	# exceptions
	if language.get_exceptions != ""
		outfile('hyp') do |file|
			file.puts language.get_exceptions
		end
	end

	# characters
	outfile('chr') do |file|
		language.extract_characters.each do |character|
			file.puts character
		end
	end

	# comments and licence
	outfile('lic') do |file|
		file.puts language.get_comments_and_licence
	end
end
