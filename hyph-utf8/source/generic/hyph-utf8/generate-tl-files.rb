#!/usr/bin/env ruby
# encoding: utf-8

# this file auto-generates tlpsrc files for hyphenation patterns - to be improved

require_relative 'languages.rb'
include Language::TeXLive


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
	if dependency = Language.dependency(collection)
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

def make_doc_file_list(collection)
	files_doc = []

	Language.packages[collection].each do |language|
		# add documentation
		if dirlist('doc').include?(language.code) then
			files_doc << sprintf("doc/generic/hyph-utf8/languages/%s", language.code)
		end
	end

	# documentation
	if collection == "greek" then
		files_doc << "doc/generic/elhyphen"
	elsif collection == "hungarian" then
		files_doc << "doc/generic/huhyphen"
	end

	files_doc
end

def make_src_file_list(collection)
	files_src = []
	Language.packages[collection].each do |language|
		# add sources
		if dirlist('source').include?(language.code) then
			files_src << sprintf("source/generic/hyph-utf8/languages/%s", language.code)
		end
	end

	files_src
end

def make_run_file_list(collection)
	files = []
	files << "tex/generic/hyph-utf8/patterns/tex/hyph-no.tex" if collection == "norwegian"

  languages = Language.packages[collection]

  files = languages.inject(files) do |files, language|
	  files + make_individual_run_file_list(language)
	end

	unless Language.dependency(collection)
		languages.each do |language|
			if language.use_old_patterns and language.filename_old_patterns != "zerohyph.tex" and language.code != 'cop'
				files << sprintf("tex/generic/hyphen/%s", language.filename_old_patterns)
			end
		end
	end

	files
end

def make_individual_run_file_list(language)
	return [] if language.use_old_loader

	files = []

	files_path_hyph8 = "tex/generic/hyph-utf8"
	files << File.join(PATH::HYPHU8, 'loadhyph', language.loadhyph)
	if language.has_quotes
		files << File.join(PATH::HYPHU8, 'patterns', 'quote', sprintf("hyph-quote-%s.tex", language.code))
	end

	if (code = language.code) =~ /^sh-/
		files << File.join(PATH::HYPHU8, 'patterns', 'tex', sprintf('hyph-%s.tex', language.code))
		files << File.join(PATH::HYPHU8, 'patterns', 'ptex', sprintf('hyph-%s.%s.tex', language.code, language.encoding))
		# duplicate entries (will be removed later)
		files << File.join(PATH::HYPHU8, 'patterns', 'tex', 'hyph-sr-cyrl.tex')
		['chr', 'pat', 'hyp', 'lic'].each do |t|
			files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-%s.%s.txt', language.code, t))
			# duplicate entries (will be removed later)
			files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-sr-cyrl.%s.txt', t))
		end
	else
		files << File.join(PATH::HYPHU8, 'patterns', 'tex', sprintf('hyph-%s.tex', language.code))
		if language.encoding && language.encoding != "ascii" then
			files << File.join(PATH::HYPHU8, 'patterns', 'ptex', sprintf('hyph-%s.%s.tex', language.code, language.encoding))
		elsif language.code == "cop"
			files << File.join(PATH::HYPHU8, 'patterns', 'tex-8bit', language.filename_old_patterns)
		end

		# we skip the mongolian language for luatex files
		return files if language.code == "mn-cyrl-x-lmc"

		['chr', 'pat', 'hyp', 'lic'].each do |t|
			files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-%s.%s.txt', language.code, t))
		end
	end

	files
end

#--------#
# TLPSRC #
#--------#

Language.packages.sort.each do |collection, languages|
	tlpsrcname = File.join(PATH::TLPSRC, sprintf('hyphen-%s.tlpsrc', collection))
	file_tlpsrc = File.open(tlpsrcname, 'w')
	printf "generating %s\n", tlpsrcname

	file_tlpsrc.puts "category TLCore"
	make_dependencies(collection).each do |dependency|
		file_tlpsrc.puts dependency
	end

	languages.each do |language|
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

	make_doc_file_list(collection).sort.each do |filename|
		file_tlpsrc.printf "docpattern d texmf-dist/%s\n", filename
	end

	make_src_file_list(collection).sort.each do |filename|
		file_tlpsrc.printf "srcpattern d texmf-dist/%s\n", filename
	end

	make_run_file_list(collection).sort.uniq.each do |filename|
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
	Language.packages.sort.each do |collection, languages|
		languages.each do |language|
			# main language name
			file_language_dat.printf "%s\t%s\n", language.name, language.loadhyph

			# synonyms
			language.synonyms.each do |synonym|
				file_language_dat.printf "=%s\n", synonym
			end
		end
	end
end
