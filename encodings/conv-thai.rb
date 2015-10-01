#!/usr/bin/env ruby

$path_data             = "data"
$filename_thai_enc     = File.join($path_data, "thai", "conv-utf8-hex.sed")
$filename_unicode_data = File.join($path_data, "UnicodeData.txt")


$unicode_name = Hash.new()
$unicode_type = Hash.new()
# 00F0;LATIN SMALL LETTER ETH;Ll;0;L;;;;;N;;Icelandic;00D0;;00D0
# FB01;LATIN SMALL LIGATURE FI;Ll;0;L;<compat> 0066 0069;;;;N;;;;;
# lowercase letters
File.open($filename_unicode_data).grep /^([0-9A-F]*);[^;]*;[^;]*;.*$/ do |line|
	unicode, name, lowercase, dummy1, dummy2, compat = line.split(/;/)
	if unicode.hex >= 0x0E01 and unicode.hex <= 0x0E5B then
		$unicode_name[unicode.hex] = name
		$unicode_type[unicode.hex] = lowercase
	end
end

enc = "lth2"
$filename_encoding2unicode = File.join($path_data, "enc2unicode", "#{enc}.dat")
$file_encoding2unicode = File.open($filename_encoding2unicode, "w")

IO.readlines($filename_thai_enc).each do |line|
	if line =~ /^s\/([^\/]*)\/\^{2}([^\/]*)/ then
		letter = $1
		code = $2.hex
		unicode_code = letter.unpack('U')[0]

		lowercase = ""
		if $unicode_type[unicode_code] =~ /(Lo|Mn)/ then
			lowercase = "1"
		end

		#puts sprintf("0x%02X\tU+%04X\t%s\t", code, unicode_code, lowercase)
		$file_encoding2unicode.puts sprintf("0x%02X\tU+%04X\t%s\t", code, unicode_code, lowercase)
		# puts sprintf("%s\t%s", $unicode_type[unicode_code], $unicode_name[unicode_code])
	else
		puts line
	end
end

$file_encoding2unicode.close