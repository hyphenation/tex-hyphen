#!/usr/bin/env ruby

load 'languages.rb'

# this file auto-generates loaders for hyphenation patterns - to be improved

$package_name="hyph-utf8"

# TODO - make this a bit less hard-coded
$path_tex_generic="../../../tex/generic"
$path_TL="../../../../TL"
$path_language_dat="#{$path_TL}/texmf/tex/generic/config"
# hyphen-foo.tlpsrc for TeX Live
$path_tlpsrc="#{$path_TL}/tlpkg/tlpsrc"

filename_language_data = "#{$path_language_dat}/language.data"
#$file_language_data = File.open(filename_language_data, "w")
$file_tlpsrc = File.open("#{$path_language_dat}/language.tlpsrc", 'w')


$l = Languages.new
# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

language_grouping = {
	'norwegian' => ['nb', 'nn'],
	'german' => ['de-1901', 'de-1996'],
	'serbian' => ['sr-latn', 'sr-cyrl'],
	'mongolian' => ['mn-cyrl', 'mn-cyrl-x-2a'],
	'greek' => ['el-monoton', 'el-polyton'],
	'ancientgreek' => ['grc', 'grc-x-ibycus'],
	'chinese' => ['zh-latn'],
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
	if language_used_in_group[language.code] == nil then
		language_groups[language.name] = [language]
	end
end
# then groups of languages
language_grouping.each do |name,group|
	language_groups[name] = []
	group.each do |code|
		language_groups[name].push($l[code])
	end
end

languages.each do |language|
	if language.hyphenmin == nil then
		lmin = ''
		rmin = ''
	else
		lmin = language.hyphenmin[0]
		rmin = language.hyphenmin[1]
	end
	puts "#{language.name}: #{lmin} #{rmin}"
end

language_groups.sort.each do |language_name,language_list|
	
	$file_tlpsrc.puts "name hyphen-#{language_name}"
	$file_tlpsrc.puts "category TLCore"
	
	language_list.each do |language|
		name = " name=#{language.name}"

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
		hyphenmins = " lefthyphenmin=#{lmin} righthyphenmin=#{rmin}"
		# which file to use
		if language.use_new_loader then
			file = " file=loadhyph-#{language.code}.tex"
		else
			file = " file=#{language.filename_old_patterns}"
		end

		$file_tlpsrc.puts "execute AddHyphen#{name}#{synonyms}#{hyphenmins}#{file}"
		
	end
	$file_tlpsrc.puts
end

$file_tlpsrc.close
