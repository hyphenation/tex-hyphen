#!/usr/bin/env ruby

path = "../../hyph-utf8/tex/generic/hyph-utf8/patterns"

# http://git.savannah.gnu.org/cgit/smc.git/tree/hyphenation
languages = %w(as bn gu hi kn ml mr or pa ta te)
#languages = %w(as)

languages.each do |language_code|
	filename = "hyph_#{language_code}_IN.dic"
	url      = "http://git.savannah.gnu.org/cgit/smc.git/plain/hyphenation/#{filename}"
	system("wget -N -c #{url}")

	lines = IO.readlines(filename, '.').join("").
		gsub(/UTF-8/, "% These patterns originate from\n%    http://git.savannah.gnu.org/cgit/smc.git/tree/hyphenation)\n% and have been adapted for hyph-utf8 (for use in TeX).\n%").
		gsub(/% GENERAL RULE/, "\\patterns{\n% GENERAL RULE") + "}\n"

	filename_out = "#{path}/hyph-#{language_code}.tex"
	file_out = File.open(filename_out, "w")
	file_out.puts(lines)
	file_out.close
end
