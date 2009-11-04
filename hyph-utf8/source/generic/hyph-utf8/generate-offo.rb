#!/usr/bin/env ruby

# this file generates FOP XML Hyphenation Patterns

# use 'gem install unicode' if unicode is missing on your computer
# require 'jcode'
# require 'rubygems'
# require 'unicode'

load 'languages.rb'

$path_OFFO="../../../../collaboration/offo"

$l = Languages.new
# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

# TODO: we should rewrite this
# not using: eo, el
# todo: mn, no!, sa, sh
# codes = ['bg', 'ca', 'cs', 'cy', 'da', 'de-1901', 'de-1996', 'de-ch-1901', 'en-gb', 'en-us', 'es', 'et', 'eu', 'fi', 'fr', 'ga', 'gl', 'hr', 'hsb', 'hu', 'ia', 'id', 'is', 'it', 'kmr', 'la', 'lt', 'lv', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sr-cyrl', 'sv', 'tr', 'uk']

language_codes = Hash.new
languages.each do |language|
	language_codes[language.code] = language.code
end
language_codes['de-1901']      = 'de_1901'
language_codes['de-1996']      = 'de'
language_codes['de-ch-1901']   = 'de_CH'
language_codes['en-gb']        = 'en_GB'
language_codes['en-us']        = 'en_US'
language_codes['zh-latn']      = 'zh_Latn'
language_codes['el-monoton']   = 'el'
language_codes['el-polyton']   = 'el_polyton'
language_codes['mn-cyrl']      = 'mn_Cyrl'
language_codes['mn-cyrl-x-2a'] = 'mn'
language_codes['sh-latn']      = 'sr_Latn'
language_codes['sh-cyrl']      = nil
language_codes['sr-cyrl']      = 'sr_Cyrl'

languages.each do |language|
	include_language = language.use_new_loader
	code = language_codes[language.code]
	if code == nil
		include_language = false
	end
	if code == 'en_US'
		include_language = true
	end

	if include_language
		puts "generating #{code}"
	
		$file_offo_pattern = File.open("#{$path_OFFO}/#{code}.xml", 'w')

		$file_offo_pattern.puts '<?xml version="1.0" encoding="utf-8"?>'
		$file_offo_pattern.puts '<hyphenation-info>'
		$file_offo_pattern.puts

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
		patterns   = language.get_patterns
		exceptions = language.get_exceptions

		if code == 'nn' or code == 'nb'
			patterns = ""
			patterns = $l['no'].get_patterns
		end

		$file_offo_pattern.puts "<hyphen-min before=\"#{lmin}\" after=\"#{rmin}\"/>"
		$file_offo_pattern.puts
		$file_offo_pattern.puts '<exceptions>'
		if exceptions != ""
			$file_offo_pattern.puts exceptions
		end
		$file_offo_pattern.puts '</exceptions>'
		$file_offo_pattern.puts
		$file_offo_pattern.puts '<patterns>'
		patterns.each do |pattern|
			$file_offo_pattern.puts pattern.gsub(/'/,"’")
		end
		$file_offo_pattern.puts '</patterns>'
		$file_offo_pattern.puts '</hyphenation-info>'

		$file_offo_pattern.close
	end
end
