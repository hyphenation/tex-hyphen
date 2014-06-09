#!/usr/bin/env ruby
# encoding: utf-8

encodings = ["ec", "qx", "latin7x", "t8m", "lth"]
encodings = ["ec"]
# "texnansi", "t5", "lt"

$path_data         = "data"
$filename_AGL      = File.join($path_data, "aglfn13.txt")

$filename_unicode_data = File.join($path_data, "UnicodeData.txt")

$AGL_names = Hash.new()


# read from adobe glyph list
File.open($filename_AGL).grep /^[0-9A-F]+/ do |line|
	unicode, pdfname = line.split(/;/)
	$AGL_names[pdfname] = unicode;
end

$lowercase_letter = Hash.new()
# 00F0;LATIN SMALL LETTER ETH;Ll;0;L;;;;;N;;Icelandic;00D0;;00D0
# FB01;LATIN SMALL LIGATURE FI;Ll;0;L;<compat> 0066 0069;;;;N;;;;;
# lowercase letters
#File.open($filename_unicode_data).grep /^([0-9A-F]*);[^;]*;Ll;.*$/ do |line|
File.open($filename_unicode_data).grep /^([0-9A-F]*);.*$/ do |line|
	unicode, name, lowercase, dummy1, dummy2, compat = line.split(/;/)
	if lowercase == "Ll" then
		unless compat.include?("compat")
			$lowercase_letter[unicode] = true
		end
	# Thai
	elsif unicode.hex >= 0x0E01 and unicode.hex <= 0x0E5B then
		if lowercase =~ /(Lo|Mn)/ then
			$lowercase_letter[unicode] = true
		end
	# Georgian lowercase (lowercase: 'Lo')
	elsif unicode.hex >= 0x10D0 and unicode.hex <= 0x10FA then
		$lowercase_letter[unicode] = true
	end
end


# ij
$lowercase_letter["0133"] = true
# florin
$lowercase_letter["0192"] = false
# ell
$lowercase_letter["2113"] = false

$AGL_names["hyphenchar"] = $AGL_names["hyphen"]
$AGL_names["sfthyphen"] = "00AD"
$AGL_names["hyphen.alt"] = "00AD"

$AGL_names["dotlessj"] = "0237"
$AGL_names["tcedilla"] = "0163"
$AGL_names["Tcedilla"] = "0162"

$AGL_names["ff"]  = "FB00" # = 0066 + 0066
$AGL_names["fi"]  = "FB01" # = 0066 + 0069
$AGL_names["fl"]  = "FB02" # = 0066 + 006C
$AGL_names["ffi"] = "FB03" # = 0066 + 0066 + 0069
$AGL_names["ffl"] = "FB04" # = 0066 + 0066 + 006C

$AGL_names["cwm"] = "200B"
$AGL_names["zerowidthspace"] = "200B"
$AGL_names["perthousandzero"] = "?"
$AGL_names["visiblespace"] = "2423"
#$AGL_names["nbspace"] = "00A0"
$AGL_names["nonbreakingspace"] = "00A0"
$AGL_names["Germandbls"] = "1E9E" # = 0053 + 0053
$AGL_names["ell"] = "2113"

$AGL_names[".notdef"] = "?"

$AGL_names["onesuperior"] = "00B9"
$AGL_names["twosuperior"] = "00B2"
$AGL_names["threesuperior"] = "00B3"

$AGL_names["anglearc"] = "2222"
$AGL_names["diameter"] = "2300"
$AGL_names["dottedcircle"] = "25CC"
$AGL_names["threequartersemdash"] = "?"
$AGL_names["f_k"] = "?"

# actually wrong
$AGL_names["perthousandzero"] = "2030"

$punct = Hash.new
$punct["0020"] = "space character|SP"
$punct["0021"] = "Exclamation mark|!"
$punct["0022"] = "Quotation mark|&#x22;"
$punct["0023"] = "Number sign|#"
$punct["0024"] = "Dollar sign|$"
$punct["0025"] = "Percent sign|%"
$punct["0026"] = "Ampersand|&amp;"
$punct["0027"] = "Apostrophe|&#x27;"
$punct["0028"] = "Bracket|("
$punct["0029"] = "Bracket|)"
$punct["002A"] = "Asterisk|*"
$punct["002B"] = "Plus and minus signs|+"
$punct["002C"] = "Comma (punctuation)|,"
$punct["002D"] = "Plus and minus signs|-"
$punct["002E"] = "Full stop|."
$punct["002F"] = "Slash (punctuation)|/"
$punct["003A"] = "colon (punctuation)|&#x3A;"
$punct["003B"] = "semicolon|&#x3B;"
$punct["003C"] = "less-than sign|&#x3C;"
$punct["003D"] = "equals sign|&#x3D;"
$punct["003E"] = "greater-than sign|&#x3E;"
$punct["003F"] = "question mark|&#x3F;"
$punct["0040"] = "@"
$punct["005B"] = "Square bracket|&#x5B;"
$punct["005C"] = "Backslash|&#x5C;"
$punct["005D"] = "Square bracket|&#x5D;"
$punct["005E"] = "Circumflex|^"
$punct["005F"] = "Underscore|_"
$punct["0060"] = "Grave accent|`"
$punct["007B"] = "Brace (punctuation)|{"
$punct["007C"] = "Vertical bar|&#x7C;"
$punct["007D"] = "Brace (punctuation)|}"
$punct["007E"] = "Tilde|~"

$ext_punct = Hash.new()
$ext_punct["00A0"] = "Non-breaking space|NBSP"
# $ext_punct["02D8"] = "Breve|˘"
$ext_punct["00A4"] = "Currency (typography)|¤"
$ext_punct["00A7"] = "Section sign|§"
$ext_punct["00A8"] = "¨"
$ext_punct["00AD"] = "Soft hyphen|SHY"
$ext_punct["00B0"] = "Degree symbol|°"
$ext_punct["02DB"] = "Ogonek|˛"
$ext_punct["00B4"] = "Acute accent|´"
$ext_punct["02C7"] = "Caron|ˇ"
$ext_punct["00B8"] = "Cedilla|¸"
$ext_punct["02DD"] = "Double acute accent|˝"
$ext_punct["00D7"] = "Multiplication sign|×"
$ext_punct["00F7"] = "Obelus|÷"
$ext_punct["02D9"] = "Dot (diacritic)|˙"

$ext_punct["02C6"] = "Circumflex|ˆ"
$ext_punct["02DC"] = "Tilde|˜"
$ext_punct["02DA"] = "Ring_(diacritic)|˚"
$ext_punct["02D8"] = "Breve|˘"
$ext_punct["00AF"] = "Macron|¯"

$ext_punct["201A"] = "‚"
$ext_punct["2039"] = "Guillemet|‹"
$ext_punct["203A"] = "Guillemet|›"

$ext_punct["201C"] = "|“"
$ext_punct["201D"] = "|”"
$ext_punct["201E"] = "|„"
$ext_punct["2019"] = "’"
$ext_punct["2018"] = "‘"

$ext_punct["00AB"] = "Guillemet|«"
$ext_punct["00BB"] = "Guillemet|»"
$ext_punct["2013"] = "–"
$ext_punct["2014"] = "—"
$ext_punct["200B"] = "Zero-width space|ZWSP"
$ext_punct["2030"] = "Per mil|‰"
# TODO: this is letter!!!
$ext_punct["0131"] = "Dotted and dotless I|ı"
$ext_punct["0237"] = "Dotless j|ȷ"
# TODO: intl-var
$ext_punct["FB00"] = "Typographic ligature#Stylistic ligatures|ﬀ"
$ext_punct["FB01"] = "Typographic ligature#Stylistic ligatures|ﬁ"
$ext_punct["FB02"] = "Typographic ligature#Stylistic ligatures|ﬂ"
$ext_punct["FB03"] = "Typographic ligature#Stylistic ligatures|ﬃ"
$ext_punct["FB04"] = "Typographic ligature#Stylistic ligatures|ﬄ"
$ext_punct["2423"] = "Space (punctuation)|␣"

# TODO: Eth and permil need a -box and a footnote
# TODO: A1 and BF are punctuation

encodings.each do |enc|
	puts "Writing files for encoding '#{enc}'"

	$filename_encoding         = File.join($path_data, "enc/#{enc}.enc")
	$filename_encoding2unicode = "/tmp/#{enc}.dat"

	printf("{| {{chset-tableformat}}\n{{chset-table-header|Cork encoding}}}\n")

	$file_encoding2unicode = File.open($filename_encoding2unicode, "w")

	i = 0
	#$file_out = File.open("#{enc}.txt", "w")
	# read from adobe glyph list
	File.open($filename_encoding).grep(/\/[_a-zA-Z0-9\.]+/) do |line|
		# ignore comments
		line.gsub!(/%.*/,'')
		# encoding name should not be considered
		line.gsub!(/.*\[/,'')
		# nor the ending definition
		line.gsub!(/\].*/,'')
	
		line.scan(/[_a-zA-Z0-9\.]+/) do |w|
			if i%16 == 0 then
				printf("|-\n!{{chset-left|%X}}\n", i/16)
			end
			# Adobe Glyph List doesn't contain uniXXXX names,
			# so we add that particular uniXXXX to our list for easier handling later on
			if w =~ /^uni(.*)$/ then
				$AGL_names[w] = $1
			end
			# if the glyph is not in AGL and isn't uniXXXX, print a warning
			if $AGL_names[w] == nil then
				puts sprintf(">> error: %s unknown (index 0x%02X)", w, i)
			else
				#$file_out.printf("%3s %-20s %s\n", i.to_s, w, $AGL_names[w])
				#puts w + " " + $AGL_names[w]
				if $AGL_names[w] == "?"
					# $file_map.printf("; %-20s: no Unicode mapping assigned\n", w);
					# $file_fixed_enc.printf("/%-15s %% 0x%02X\n", w, i);
					$file_encoding2unicode.printf("0x%02X\tU+....\t\t%s\n", i, w);
					printf("0x%02X\tU+....\t\t%s\n", i, w);
				# somewhat unreliable way to filter out uniXXXX.something
				elsif $AGL_names[w].size > 4 then
					# $file_map.printf("; %-20s: no unique way to map to Unicode\n", w);
					# $file_fixed_enc.printf("/%-15s %% 0x%02X U+%s\n", w, i, $AGL_names[w]);
					$file_encoding2unicode.printf("0x%02X\tU+....\t\t%s\n", i, w);
					printf("0x%02X\tU+....\t\t%s\n", i, w);
				else
					unicode_point = $AGL_names[w]
					if i != $AGL_names[w].hex
						# $file_map.printf("%d\t<>\tU+%s\t; %s\n", i, unicode_point, w);
						# $file_fixed_enc.printf("/%-15s %% 0x%02X U+%s\n", w, i, unicode_point);
					else
						# $file_map.printf("%d\t<>\tU+%s\t; %s\n", i, unicode_point, w);
						# $file_fixed_enc.printf("/%-15s %% 0x%02X\n", w, i);
					end
					lowercase = ""
					if $lowercase_letter[unicode_point] == true and unicode_point.hex > 127
						lowercase = "1"
						# exception: in Thai, we don't want any characted below 0xA0
						if enc == "lth" and i < 0xA0 then
							lowercase = ""
						end
					end
					type = ""
					unichar = [unicode_point.to_i(16)].pack('U')
					cell = unichar
					if i >= 'a'.ord and i <= 'z'.ord then
						type = "alpha"
					elsif i >= 'A'.ord and i <= 'Z'.ord then
						type = "alpha"
					elsif i >= '0'.ord and i <= '9'.ord then
						type = "digit"
						cell = sprintf("%s (number)|%s", unichar, unichar)
					elsif i >= 128 then
						type = "intl"
					elsif $punct[unicode_point] != nil then
						type = "punct"
						cell = $punct[unicode_point]
					elsif $ext_punct[unicode_point] != nil then
						type = "ext-punct"
						cell = $ext_punct[unicode_point]
					else
						type = "TODO"
						cell = unichar
					end
					$file_encoding2unicode.printf("0x%02X\tU+%s\t%s\t%s\n", i, unicode_point, lowercase, w);
					printf("|{{chset-color-%s}}|{{chset-cell3|%s|[[%s]]|%d|%o}}\n", type, unicode_point, cell, i, i);  # w - character name
				end
			end
			i = i.next
		end
	end
	printf("{{chset-table-footer}}\n|}\n")

	$file_encoding2unicode.close
end
