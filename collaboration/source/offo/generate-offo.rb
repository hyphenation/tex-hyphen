#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# this file generates FOP XML Hyphenation Patterns

# use 'gem install unicode' if unicode is missing on your computer
# require 'jcode'
# require 'rubygems'
# require 'unicode'

# this script
# collaboration/source/offo
$path_to_top = '../../..'

# languages.rb
# hyph-utf8/source/generic/hyph-utf8
$path_lang = 'hyph-utf8/source/generic/hyph-utf8'
load "#{$path_to_top}/#{$path_lang}/languages.rb"

# modify methods of class Language
class Language
	# TODO: simplify this (reduce duplication)

	def get_exceptions(pattern_path)
		if @exceptions1 == nil
          filename = "#{pattern_path}/hyph-#{@code}.hyp.txt";
			lines = IO.readlines(filename, '.').join("")
			exceptions = lines.gsub(/%.*/,'');
			@exceptions1 = exceptions.
				gsub(/\s+/m,"\n").
				gsub(/^\s*/m,'').
				gsub(/\s*$/m,'').
				split("\n")
		end

		return @exceptions1
	end

	def get_patterns(pattern_path)
		if @patterns == nil
			filename = "#{pattern_path}/hyph-#{@code}.pat.txt"
			lines = IO.readlines(filename, '.').join("")
			@patterns = lines.gsub(/%.*/,'').
				gsub(/\s+/m,"\n").
				gsub(/^\s*/m,'').
				gsub(/\s*$/m,'').
				split("\n")

			if @code == 'eo' then
				@patterns = lines.gsub(/%.*/,'').
					#
					gsub(/\\adj\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e.').
					gsub(/\\nom\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e. \1o. \1oj. \1ojn. \1on.').
					gsub(/\\ver\{(.*?)\}/m,'\1as. \1i. \1is. \1os. \1u. \1us.').
					#
					gsub(/\s+/m,"\n").
					gsub(/^\s*/m,'').
					gsub(/\s*$/m,'').
					split("\n")
			end
		end
		return @patterns
	end

	def get_comments_and_licence(pattern_path)
		if @comments_and_licence == nil then
			filename = File.expand_path("#{pattern_path}/hyph-#{@code}.lic.txt");
			lines = IO.readlines(filename)
			@comments_and_licence = lines
		end
		return @comments_and_licence
	end

    def get_classes(pattern_path)
        if @classes == nil then
            filename = File.expand_path("#{pattern_path}/hyph-#{@code}.chr.txt");
			lines = IO.readlines(filename, '.').join("")
			@classes = lines
		end
		return @classes
    end

end

# source patterns
# hyph-utf8/tex/generic/hyph-utf8/patterns/txt
$path_src_pat = 'hyph-utf8/tex/generic/hyph-utf8/patterns/txt'

# XML patterns
# collaboration/repository/offo
$path_offo = "collaboration/repository/offo"

$rel_path_offo = "#{$path_to_top}/#{$path_offo}"
$rel_path_patterns = "#{$path_to_top}/#{$path_src_pat}"

$l = Languages.new()
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
language_codes['el-monoton']   = 'el'
language_codes['el-polyton']   = 'el_Polyton'
language_codes['en-gb']        = 'en_GB'
# FOP requires a pattern file for en; use the US patterns
language_codes['en-us']        = 'en'
# hu patterns cause a stack overflow when compiled with FOP
language_codes['hu']           = nil
language_codes['mn-cyrl']      = 'mn'
language_codes['mn-cyrl-x-lmc'] = nil # no such pattern
language_codes['mul-ethi']     = 'mul_ET'
language_codes['sh-cyrl']      = 'sr_Cyrl'
language_codes['sh-latn']      = 'sr_Latn'
language_codes['zh-latn-pinyin']      = 'zh_Latn'

# How can I sort on language_codes?
# language_codes[a.code] <=> language_codes[b.code] fails.
# It would be nice to apply here the filter
# code != nil && include_language = true.
languages = $l.list.sort{|a,b| a.code <=> b.code}

$languages_info = File.open("#{$rel_path_offo}/info/languages-info.xml", 'w')
$languages_info.puts '<?xml version="1.0" encoding="utf-8"?>'
$languages_info.puts '<?xml-stylesheet type="text/xsl" href="languages-info.xsl"?>'
$languages_info.puts '<!DOCTYPE languages-info PUBLIC "-//OFFO//DTD LANGUAGES INFO 1.0//EN" "languages-info.dtd">'
$languages_info.puts '<languages-info>'

languages.each do |language|
	include_language = language.use_new_loader
	code = language_codes[language.code]
	if code == nil
		include_language = false
	end

	if include_language
		puts "generating #{code}"
        $languages_info.puts '<language>'
        $languages_info.puts "<name>#{language.name}</name>"
        $languages_info.puts "<tex-code>#{language.code}</tex-code>"
        $languages_info.puts "<code>#{code}</code>"
        $languages_info.puts "<message>#{language.message}</message>"
        $languages_info.puts '</language>'
	
		$file_offo_pattern = File.open("#{$rel_path_offo}/#{code}.xml", 'w')

        comments_and_licence = language.get_comments_and_licence($rel_path_patterns)
        # do not use classes (SP 2010/10/26)
        # classes    = language.get_classes
        classes = nil
		exceptions = language.get_exceptions($rel_path_patterns)
		patterns   = language.get_patterns($rel_path_patterns)

		# if code == 'nn' or code == 'nb'
		# 	patterns = ""
		# 	patterns = $l['no'].get_patterns
		# end

		$file_offo_pattern.puts '<?xml version="1.0" encoding="utf-8"?>'
		$file_offo_pattern.puts '<hyphenation-info>'
		$file_offo_pattern.puts

        # comments and license, optional
        if comments_and_licence != "" then
            comments_and_licence.each do |line|
               $file_offo_pattern.puts line.
                   gsub(/--/,'‐‐').
                   gsub(/%/,'').
                   gsub(/^\s*(\S+.*)$/, '<!-- \1 -->')
            end
    		$file_offo_pattern.puts
        end
        
        # hyphenmin, optional
		if language.hyphenmin != nil and language.hyphenmin.length != 0 then
            $file_offo_pattern.puts "<hyphen-min before=\"#{language.hyphenmin[0]}\" after=\"#{language.hyphenmin[1]}\"/>"
            $file_offo_pattern.puts
        end
      
        # classes, optional
        if classes != nil then
            $file_offo_pattern.puts '<classes>'
			$file_offo_pattern.puts classes
            $file_offo_pattern.puts '</classes>'
		    $file_offo_pattern.puts
		end
            
        # exceptions, optional
		if exceptions != ""
            $file_offo_pattern.puts '<exceptions>'
			$file_offo_pattern.puts exceptions
            $file_offo_pattern.puts '</exceptions>'
            $file_offo_pattern.puts
		end

        # patterns
		$file_offo_pattern.puts '<patterns>'
		patterns.each do |pattern|
			$file_offo_pattern.puts pattern.gsub(/'/,"’")
		end
		$file_offo_pattern.puts '</patterns>'
		$file_offo_pattern.puts

		$file_offo_pattern.puts '</hyphenation-info>'

		$file_offo_pattern.close
	end
end

$languages_info.puts '</languages-info>'
$languages_info.close
