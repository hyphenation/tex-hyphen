#!/usr/bin/env ruby
# encoding: utf-8

# this file generates plain patterns (one-per-line) out of TeX source

# use 'gem install unicode' if unicode is missing on your computer

require_relative 'lib/tex/hyphen/language.rb'
# include OldLanguage::TeXLive
include TeX::Hyphen

# FIXME Close files!
# FIXME sr-cyrl?
print '[1;36mGenerating[0m [0;34mplain files[0m for (parenthesised tags are skipped) '
Language.all.sort.each do |language|
	bcp47 = language.bcp47

	if language.use_old_loader || bcp47 == 'mn-cyrl-x-lmc'
		print '([0;31m', language.bcp47, '[0m) '
		next
	else
		print '[0;32m', bcp47, '[0m '
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

	### FIXME Do issue #33 instead
	### # characters
	### file = outfile.('chr')
	### language.extract_characters.each do |character|
	### 	file.puts character
	### end

	### FIXME Do something else instead
	### # comments and licence
	### file = outfile.('lic')
	### file.puts language.comments_and_licence

	### file.close
end
puts
