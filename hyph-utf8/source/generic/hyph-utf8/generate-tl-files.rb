#!/usr/bin/env ruby
# encoding: utf-8

# this file auto-generates tlpsrc files for hyphenation patterns - to be improved

require_relative 'languages.rb'
include Language::TeXLive
include TeXLive

$dirlist = Hash.new
def dirlist(type)
	$dirlist[type] ||= Dir.glob(File.expand_path(sprintf('../../../../%s/generic/hyph-utf8/languages/*', type), __FILE__)).select do |file|
		File.directory?(file)
	end.map do |dir|
		dir.gsub /^.*\//, ''
	end
end

def make_dependencies(collection)
  dependencies = [
		"depend hyphen-base",
		"depend hyph-utf8",
	]

	# external dependencies
	if dependency = Package.has_dependency?(collection)
		dependencies << sprintf("depend %s", dependency)
	end

	dependencies
end

def make_synonyms(language)
	# synonyms
	if language.synonyms && language.synonyms.length > 0
		sprintf " synonyms=%s", language.synonyms.join(',')
	else
		''
	end
end

def make_hyphenmins(language)
	# lefthyphenmin/righthyphenmin
	lmin = (language.hyphenmin || [])[0]
	rmin = (language.hyphenmin || [])[1]
	sprintf "lefthyphenmin=%s \\\n\trighthyphenmin=%s", lmin, rmin
end

def make_file_line(language)
	# which file to use
	if language.use_old_loader
		file = sprintf "file=%s", language.filename_old_patterns
		if ['ar', 'fa'].include? language.code
			file = file + " \\\n\tfile_patterns="
		elsif language.code == 'grc-x-ibycus' then
			# TODO: fix this
			file = file + " \\\n\tluaspecial=\"disabled:8-bit only\""
		end
	else
		file = sprintf "file=%s", language.loadhyph
	end
end

#--------#
# TLPSRC #
#--------#

# require 'byebug'; byebug
Package.all.sort.each do |package|
	tlpsrcname = File.join(PATH::TLPSRC, sprintf('hyphen-%s.tlpsrc', package.name))
	file_tlpsrc = File.open(tlpsrcname, 'w')
	printf "generating %s\n", tlpsrcname

	file_tlpsrc.puts "category TLCore"
	make_dependencies(package.name).each do |dependency|
		file_tlpsrc.puts dependency
	end

	package.languages.each do |language|
		if language.description_s && language.description_l then
			file_tlpsrc.printf "shortdesc %s.\n", language.description_s
			language.description_l.each do |line|
				file_tlpsrc.printf "longdesc %s\n", line
			end
		end

		file_tlpsrc.printf  "execute AddHyphen \\\n\tname=%s%s \\\n", language.name, make_synonyms(language)
		file_tlpsrc.printf "\t%s \\\n\t%s", make_hyphenmins(language), make_file_line(language)
		if language.patterns_line + language.exceptions_line != ""
			file_tlpsrc.printf " \\\n\t%s \\\n\t%s", language.patterns_line, language.exceptions_line
		end
		if language.code == "mn-cyrl-x-lmc" then
			file_tlpsrc.printf " \\\n\tluaspecial=\"disabled:only for 8bit montex with lmc encoding\""
		end
		# end-of-line
		file_tlpsrc.puts
	end

	package.list_doc_files.sort.each do |filename|
		file_tlpsrc.printf "docpattern d texmf-dist/%s\n", filename
	end

	package.list_src_files.sort.each do |filename|
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
			file_language_dat.printf "%s\t%s\n", language.name, language.loadhyph

			# synonyms
			language.synonyms.each do |synonym|
				file_language_dat.printf "=%s\n", synonym
			end
		end
	end
end
