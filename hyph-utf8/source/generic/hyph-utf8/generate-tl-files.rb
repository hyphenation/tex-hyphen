#!/usr/bin/env ruby
# encoding: utf-8

# this file auto-generates tlpsrc files for hyphenation patterns - to be improved

require_relative '../../../../lib/tex/hyphen/language.rb'
include OldLanguage::TeXLive
# include TeXLive # TODO Restore when migration is over
include TeX::Hyphen

#--------#
# TLPSRC #
#--------#

Package.all.sort.each do |package|
	tlpsrcname = File.join(PATH::TLPSRC, sprintf('hyphen-%s.tlpsrc', package.name.safe))
	file_tlpsrc = File.open(tlpsrcname, 'w')
	printf "generating %s\n", tlpsrcname

	file_tlpsrc.puts "category TLCore"
	package.list_dependencies.each do |dependency|
		file_tlpsrc.puts dependency
	end

	# FIXME Still doesn’t work well for Latin
	file_tlpsrc.printf "shortdesc %s.\n", package.description_s
	package.description_l.each do |line|
		file_tlpsrc.printf "longdesc %s\n", line
	end
	package.languages.each do |language|
		if language.description_s && language.description_l then
			# file_tlpsrc.printf "shortdesc %s.\n", language.description_s
			# language.description_l.each do |line|
			# 	file_tlpsrc.printf "longdesc %s\n", line
			# end
		end

		file_tlpsrc.printf  "execute AddHyphen \\\n\tname=%s%s \\\n", language.name.safe, language.list_synonyms
		file_tlpsrc.printf "\t%s \\\n\t%s", language.list_hyphenmins, language.list_loader
		if language.patterns_line + language.exceptions_line != ""
			file_tlpsrc.printf " \\\n\t%s \\\n\t%s", language.patterns_line, language.exceptions_line
		end
		if language.code == "mn-cyrl-x-lmc" then
			file_tlpsrc.printf " \\\n\tluaspecial=\"disabled:only for 8bit montex with lmc encoding\""
		end
		# end-of-line
		file_tlpsrc.puts
	end

	# documentation
	package.list_support_files('doc').sort.each do |filename|
		file_tlpsrc.printf "docpattern d texmf-dist/%s\n", filename
	end

	# sources
	package.list_support_files('source').sort.each do |filename|
		file_tlpsrc.printf "srcpattern d texmf-dist/%s\n", filename
	end

	package.list_run_files.sort.uniq.each do |filename|
		file_tlpsrc.printf "runpattern f texmf-dist/%s\n", filename
	end
	file_tlpsrc.close
end

#--------------#
# language.dat #
#--------------#
language_dat_filename = File.join PATH::LANGUAGE_DAT, 'language.dat'
File.open(language_dat_filename, 'w') do |file_language_dat|
	printf "Generating %s\n", language_dat_filename
	Package.all.sort.each do |package|
		package.languages.each do |language|
			# main language name
			file_language_dat.printf "%s\t%s\n", language.name.safe, language.loadhyph

			# synonyms
			language.synonyms.each do |synonym|
				file_language_dat.printf "=%s\n", synonym
			end
		end
	end
end
