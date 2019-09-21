#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer
require 'unicode'

require_relative 'lib/tex/hyphen/language.rb'
# include OldLanguage::TeXLive
include TeX::Hyphen

# FIXME Close files!
# FIXME sr-cyrl?
print 'Generating plain files for (parenthesised tags are skipped) '
Language.all.sort.each do |language|
	bcp47 = language.bcp47

	if language.use_old_loader || bcp47 == 'mn-cyrl-x-lmc'
		print '(', language.bcp47, ') '
		next
	else
		print bcp47, ' '
	end

	outfile = Proc.new do |ext|
		File.open File.join(PATH::TXT, sprintf('hyph-%s.%s.txt', bcp47, ext)), 'w'
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
		file = File.open File.join(PATH::QUOTE, sprintf('hyph-quote-%s.tex', bcp47)), 'w'
		file.printf "\\bgroup\n\\lccode`\\’=`\\’\n\\patterns{\n"
		with_apostrophe.each do |pattern|
			file.printf "%s\n", pattern
		end
		file.puts "}\n\\egroup\n"
	end

	# exceptions
	unless language.exceptions == ""
		file = outfile.('hyp') # This ensure a file is created, even if it may be empty
		file.puts language.exceptions
	end

	File.open(File.join(PATH::TXT, sprintf('hyph-%s.yaml', bcp47)), 'w') do |file_yaml|
		file_yaml.puts language.yaml
		file_yaml.puts "characters:"
		language.extract_characters.each do |character|
			file_yaml.puts "    - #{character}"
		end
		file_yaml.close
	end

	### file.close
end
puts
