#!/usr/bin/env ruby
# encoding: utf-8

# this file auto-generates tlpsrc files for hyphenation patterns - to be improved

require_relative 'languages.rb'

$package_name="hyph-utf8"

# TODO - make this a bit less hard-coded
$path_tex_generic=File.expand_path("../../../../tex/generic", __FILE__)
$path_TL=File.expand_path("../../../../../TL", __FILE__)
$path_language_dat="#{$path_TL}/texmf-dist/tex/generic/config"
# hyphen-foo.tlpsrc for TeX Live
$path_tlpsrc="#{$path_TL}/tlpkg/tlpsrc"

$path_txt="#{$path_tex_generic}/#{$package_name}/patterns/txt"

$l = Languages.new
# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

language_grouping = {
	'english' => ['en-gb', 'en-us'],
	'norwegian' => ['nb', 'nn'],
	'german' => ['de-1901', 'de-1996', 'de-ch-1901'],
	'mongolian' => ['mn-cyrl', 'mn-cyrl-x-lmc'],
	'greek' => ['el-monoton', 'el-polyton'],
	'ancientgreek' => ['grc', 'grc-x-ibycus'],
	'chinese' => ['zh-latn-pinyin'],
	'indic' => ['as', 'bn', 'gu', 'hi', 'kn', 'ml', 'mr', 'or', 'pa', 'ta', 'te'],
	'serbian' => ['sh-latn', 'sh-cyrl'],
	'latin' => ['la', 'la-x-classic', 'la-x-liturgic'],
}

language_used_in_group = Hash.new
language_grouping.each_value do |group|
	group.each do |code|
		language_used_in_group[code] = true
	end
end

# a hash with language name as key and array of languages as the value
language_groups = Hash.new
# single languages first
languages.each do |language|
	# temporary remove cyrilic serbian until someone explains what is needed
	if language.code == 'sr-cyrl' or language.code == 'en-us' then
		# ignore the language
	elsif language_used_in_group[language.code] == nil then
		language_groups[language.name] = [language]
	end

	if language.code == 'sh-latn' then
		language.code = 'sr-latn'
	elsif language.code == 'sh-cyrl' then
		language.code = 'sr-cyrl'
	end
end

# then groups of languages
language_grouping.each do |name,group|
	language_groups[name] = []
	group.each do |code|
		language_groups[name].push($l[code])
	end
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
language_groups.sort.each do |language_name,language_list|
	files_path_hyph8 = "tex/generic/hyph-utf8"
	files_run = []
	files_doc = []
	files_src = []
	$file_tlpsrc = File.open("#{$path_tlpsrc}/hyphen-#{language_name}.tlpsrc", 'w')
	puts "generating #{$path_tlpsrc}/hyphen-#{language_name}.tlpsrc"
	
	#$file_tlpsrc.puts "name hyphen-#{language_name}"
	$file_tlpsrc.puts "category TLCore"
	$file_tlpsrc.puts "depend hyphen-base"
	$file_tlpsrc.puts "depend hyph-utf8"

	# external dependencies
	if language_name == "german" then
		$file_tlpsrc.puts "depend dehyph"
	# for Russian and Ukrainian (until we implement the new functionality at least)
	elsif language_name == "russian" then
		$file_tlpsrc.puts "depend ruhyphen"
	elsif language_name == "ukrainian" then
		$file_tlpsrc.puts "depend ukrhyph"
	elsif language_name == "norwegian" then
		files_run.push("#{files_path_hyph8}/patterns/tex/hyph-no.tex")
	end
	language_list.each do |language|
		if language.description_s != nil then
			$file_tlpsrc.puts "shortdesc #{language.description_s}."
			$file_tlpsrc.puts "longdesc #{language.description_l.join("\nlongdesc ")}"
			# if language.version != nil then
			# 	$file_tlpsrc.puts "catalogue-version #{language.version}"
			# end
		end
		name = "name=#{language.name}"

		# synonyms
		if language.synonyms != nil and language.synonyms.length > 0 then
			synonyms=" synonyms=#{language.synonyms.join(',')}"
		else
			synonyms=""
		end
		# lefthyphenmin/righthyphenmin
		if language.hyphenmin == nil or language.hyphenmin.length == 0 then
			lmin = ''
			rmin = ''
		elsif language.filename_old_patterns == "zerohyph.tex" then
			lmin = ''
			rmin = ''
		else
			lmin = language.hyphenmin[0]
			rmin = language.hyphenmin[1]
		end
		hyphenmins = "lefthyphenmin=#{lmin} \\\n\trighthyphenmin=#{rmin}"
		# which file to use
		file = ""
		file_patterns = ""
		file_exceptions = ""
		if language.use_new_loader then
			file = "file=loadhyph-#{language.code}.tex"
			files_run.push("#{files_path_hyph8}/loadhyph/loadhyph-#{language.code}.tex")
			if language.has_quotes then
				files_run.push("#{files_path_hyph8}/patterns/quote/hyph-quote-#{language.code}.tex")
			end

			if language.code == "mn-cyrl-x-lmc" then
				files_run.push("#{files_path_hyph8}/patterns/tex/hyph-#{language.code}.tex")
				files_run.push("#{files_path_hyph8}/patterns/ptex/hyph-#{language.code}.#{language.encoding}.tex")
			# we skip the mongolian language for luatex files
			else
				if language.code == "sr-latn" or language.code == "sr-cyrl" then
					code = language.code.gsub(/sr/, "sh")
					filename_pat = "hyph-sh-latn.pat.txt,hyph-sh-cyrl.pat.txt"
					filename_hyp = "hyph-sh-latn.hyp.txt,hyph-sh-cyrl.hyp.txt"

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
					filename_pat = "hyph-#{language.code}.pat.txt"
					filename_hyp = "hyph-#{language.code}.hyp.txt"

					files_run.push("#{files_path_hyph8}/patterns/tex/hyph-#{language.code}.tex")
					if language.encoding != nil and language.encoding != "ascii" then
						files_run.push("#{files_path_hyph8}/patterns/ptex/hyph-#{language.code}.#{language.encoding}.tex")
					elsif language.code == "cop" then
						files_run.push("#{files_path_hyph8}/patterns/tex-8bit/#{language.filename_old_patterns}")
						# files_run.push("#{files_path_hyph8}/patterns/tex-8bit/copthyph.tex")
					end
					['chr', 'pat', 'hyp', 'lic'].each do |t|
						files_run.push("#{files_path_hyph8}/patterns/txt/hyph-#{language.code}.#{t}.txt")
					end

					# check for existance of patterns and exceptions
					if !File::exists?( "#{$path_txt}/#{filename_pat}" ) then
						puts "some problem with #{$path_txt}/#{filename_pat}!!!"
					end
					if !File::exists?( "#{$path_txt}/#{filename_hyp}" ) then
						puts "some problem with #{$path_txt}/#{filename_hyp}!!!"
					end
				end

				file_patterns   = "file_patterns=#{filename_pat}"
				if File::size?( "#{$path_txt}/#{filename_hyp}" ) != nil then
					file_exceptions = "file_exceptions=#{filename_hyp}"
				# TODO: nasty workaround
				elsif language.code == "sr-latn" or language.code == "sr-cyrl" then
					file_exceptions = "file_exceptions=#{filename_hyp}"
				else
					file_exceptions = "file_exceptions="
					# puts ">   #{filename_hyp} is empty"
				end
			end
		else
			file = "file=#{language.filename_old_patterns}"
			if language.code == 'ar' or language.code == 'fa' then
				file = file + " \\\n\tfile_patterns="
			elsif language.code == 'grc-x-ibycus' then
				# TODO: fix this
				file = file + " \\\n\tluaspecial=\"disabled:8-bit only\""
			end
		end

		$file_tlpsrc.puts  "execute AddHyphen \\\n\t#{name}#{synonyms} \\"
		$file_tlpsrc.print "\t#{hyphenmins} \\\n\t#{file}"
		if file_patterns + file_exceptions != ""
			$file_tlpsrc.print " \\\n\t#{file_patterns} \\\n\t#{file_exceptions}"
		end
		if language.code == "mn-cyrl-x-lmc" then
			$file_tlpsrc.print " \\\n\tluaspecial=\"disabled:only for 8bit montex with lmc encoding\""
		end
		# end-of-line
		$file_tlpsrc.puts

		# add sources
		if ['es', 'eu', 'gl', 'hy', 'mul-ethi', 'tk', 'tr'].include?(language.code) then
			files_src.push("source/generic/hyph-utf8/languages/#{language.code}")
		end
		# add documentation
		if ['bg', 'es', 'hu', 'sa'].include?(language.code) then
			files_doc.push("doc/generic/hyph-utf8/#{language.code}")
		end
	end
	if language_name != "german" and language_name != "russian" and language_name != "ukrainian" then
		language_list.each do |language|
			if language.use_old_patterns and language.filename_old_patterns != "zerohyph.tex" and language.filename_old_patterns != "copthyph.tex" then
				files_run.push("tex/generic/hyphen/#{language.filename_old_patterns}")
			end
		end
	end

	# documeentation
	if language_name == "greek" then
		files_doc.push("doc/generic/elhyphen")
	elsif language_name == "hungarian" then
		files_doc.push("doc/generic/huhyphen")
	end

	files_doc.sort.each do |f|
		$file_tlpsrc.puts "docpattern d texmf-dist/#{f}"
	end
	files_src.sort.each do |f|
		$file_tlpsrc.puts "srcpattern d texmf-dist/#{f}"
	end
	files_run.sort.uniq.each do |f|
		$file_tlpsrc.puts "runpattern f texmf-dist/#{f}"
	end
	$file_tlpsrc.close
end

#--------------#
# language.dat #
#--------------#
$file_language_dat = File.open("#{$path_language_dat}/language.dat", "w")
language_groups.sort.each do |language_name,language_list|
	language_list.each do |language|
		if language.use_new_loader then
			$file_language_dat.puts "#{language.name}\tloadhyph-#{language.code}.tex"
		else
			$file_language_dat.puts "#{language.name}\t#{language.filename_old_patterns}"
		end

		# synonyms
		if language.synonyms != nil then
			language.synonyms.each do |synonym|
				$file_language_dat.puts "=#{synonym}"
			end
		end
	end
end
$file_language_dat.close
