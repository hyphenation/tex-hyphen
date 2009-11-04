#!/usr/bin/env ruby

require 'jcode'
require 'rubygems'
require 'unicode'

# use 'gem install unicode' if unicode is missing on your computer

# this file generates FOP XML Hyphenation Patterns

load 'languages.rb'

$path_OFFO="../../../../collaboration/offo"

$l = Languages.new
# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

# TODO: we should rewrite this
# not using: eo, el
# todo: mn, no!, sa, sh
codes = ['bg', 'ca', 'cs', 'cy', 'da', 'de-1901', 'de-1996', 'de-ch-1901', 'en-gb', 'en-us', 'es', 'et', 'eu', 'fi', 'fr', 'ga', 'gl', 'hr', 'hsb', 'hu', 'ia', 'id', 'is', 'it', 'kmr', 'la', 'lt', 'lv', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sr-cyrl', 'sv', 'tr', 'uk']

# codes = ['sl', 'cs']

languages.each do |language|
	if codes.rindex(language.code) != nil
		$file_offo_pattern = File.open("#{$path_OFFO}/#{language.code}.xml", 'w')

		$file_offo_pattern.puts '<?xml version="1.0" encoding="utf-8"?>'
		$file_offo_pattern.puts '<hyphenation-info>'
		$file_offo_pattern.puts
		$file_offo_pattern.puts '<hyphen-char value="-"/>'

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
		$file_offo_pattern.puts "<hyphen-min before=\"#{lmin}\" after=\"#{rmin}\"/>"
		$file_offo_pattern.puts

		patterns   = language.get_patterns
		exceptions = language.get_exceptions
		characters_indexes = patterns.join('').gsub(/[.0-9]/,'').unpack('U*').sort.uniq
		# characters = characters_indexes.pack('U*')

		$file_offo_pattern.puts '<classes>'
		characters_indexes.each do |c|
			ch = [c].pack('U')
			$file_offo_pattern.puts ch + Unicode.upcase(ch)
		end
		$file_offo_pattern.puts '</classes>'
		$file_offo_pattern.puts
		$file_offo_pattern.puts '<exceptions>'
		if exceptions != ""
			$file_offo_pattern.puts exceptions
		end
		$file_offo_pattern.puts '</exceptions>'
		$file_offo_pattern.puts
		$file_offo_pattern.puts '<patterns>'
		$file_offo_pattern.puts patterns
		$file_offo_pattern.puts '</patterns>'
		$file_offo_pattern.puts '</hyphenation-info>'

		$file_offo_pattern.close
	end
end
