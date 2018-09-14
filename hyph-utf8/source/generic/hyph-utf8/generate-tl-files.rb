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
		synonyms=" synonyms=#{language.synonyms.join(',')}"
	else
		synonyms=""
	end
end

def make_hyphenmins(language)
	# lefthyphenmin/righthyphenmin
	if language.hyphenmin && language.hyphenmin.length > 0
		lmin = language.hyphenmin[0]
		rmin = language.hyphenmin[1]
	else
		lmin = ''
		rmin = ''
	end
	"lefthyphenmin=#{lmin} \\\n\trighthyphenmin=#{rmin}"
end

def make_file_line(language)
	# which file to use
	if language.use_old_loader
		file = "file=#{language.filename_old_patterns}"
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
			files_doc.push("doc/generic/hyph-utf8/languages/#{language.code}")
		end
	end

	# documentation
	if collection == "greek" then
		files_doc.push("doc/generic/elhyphen")
	elsif collection == "hungarian" then
		files_doc.push("doc/generic/huhyphen")
	end

	files_doc
end

def make_src_file_list(collection)
	files_src = []
	Language.packages[collection].each do |language|
		# add sources
		if dirlist('source').include?(language.code) then
			files_src.push("source/generic/hyph-utf8/languages/#{language.code}")
		end
	end

	files_src
end

def make_run_file_list(collection)
	full = []
	full = ["tex/generic/hyph-utf8/patterns/tex/hyph-no.tex"] if collection == "norwegian"

  languages = Language.packages[collection]

  full = languages.inject(full) do |full, language|
	  full + make_individual_run_file_list(language)
	end

	unless Language.dependency(collection)
		languages.each do |language|
			if language.use_old_patterns and language.filename_old_patterns != "zerohyph.tex" and language.code != 'cop'
				full.push("tex/generic/hyphen/#{language.filename_old_patterns}")
			end
		end
	end

	full
end

def make_individual_run_file_list(language)
	return [] if language.use_old_loader

	files_run = []

	files_path_hyph8 = "tex/generic/hyph-utf8"
	files_run.push(sprintf "%s/loadhyph/%s", files_path_hyph8, language.loadhyph)
	if language.has_quotes then
		files_run.push("#{files_path_hyph8}/patterns/quote/hyph-quote-#{language.code}.tex")
	end

	if language.code == "mn-cyrl-x-lmc" then
		files_run.push("#{files_path_hyph8}/patterns/tex/hyph-#{language.code}.tex")
		files_run.push("#{files_path_hyph8}/patterns/ptex/hyph-#{language.code}.#{language.encoding}.tex")
	# we skip the mongolian language for luatex files
	else
		if (code = language.code) =~ /^sh-/
			files_run.push("#{files_path_hyph8}/patterns/tex/hyph-#{code}.tex")
			files_run.push("#{files_path_hyph8}/patterns/ptex/hyph-#{code}.#{language.encoding}.tex")
			# duplicate entries (will be removed later)
			files_run.push("#{files_path_hyph8}/patterns/tex/hyph-sr-cyrl.tex")
			['chr', 'pat', 'hyp', 'lic'].each do |t|
				files_run.push("#{files_path_hyph8}/patterns/txt/hyph-#{code}.#{t}.txt")
				# duplicate entries (will be removed later)
				files_run.push("#{files_path_hyph8}/patterns/txt/hyph-sr-cyrl.#{t}.txt")
			end
		else
			files_run.push("#{files_path_hyph8}/patterns/tex/hyph-#{language.code}.tex")
			if language.encoding && language.encoding != "ascii" then
				files_run.push("#{files_path_hyph8}/patterns/ptex/hyph-#{language.code}.#{language.encoding}.tex")
			elsif language.code == "cop" then
				files_run.push("#{files_path_hyph8}/patterns/tex-8bit/#{language.filename_old_patterns}")
				# files_run.push("#{files_path_hyph8}/patterns/tex-8bit/copthyph.tex")
			end
			['chr', 'pat', 'hyp', 'lic'].each do |t|
				files_run.push("#{files_path_hyph8}/patterns/txt/hyph-#{language.code}.#{t}.txt")
			end
		end
	end

	files_run
end

# languages.each do |language|
# 	if language.hyphenmin == nil then
# 		lmin = ''
# 		rmin = ''
# 	else
# 		lmin = language.hyphenmin[0]
# 		rmin = language.hyphenmin[1]
# 	end
# 	puts "#{language.name}: #{lmin} #{rmin}"
# end

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
			file_tlpsrc.print "longdesc "
			language.description_l.each_with_index do |line, i|
				file_tlpsrc.print "\n longdesc " unless i == 0
				file_tlpsrc.print line
			end
			file_tlpsrc.puts
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
			if language.use_old_loader then
				file_language_dat.puts "#{language.name}\t#{language.filename_old_patterns}"
			else
				file_language_dat.puts sprintf("%s\t%s", language.name, language.loadhyph)
			end

			# synonyms
			language.synonyms.each do |synonym|
				file_language_dat.puts "=#{synonym}"
			end
		end
	end
end
