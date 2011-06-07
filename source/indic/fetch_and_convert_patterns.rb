#!/usr/bin/env ruby

# converts the patterns from upstream git repository to TeX-friendly form

path = File.expand_path("../../hyph-utf8/tex/generic/hyph-utf8/patterns/tex")

# http://git.savannah.gnu.org/cgit/smc.git/tree/hyphenation
languages = %w(as bn gu hi kn ml mr or pa ta te)
#languages = %w(as)

languages.each do |language_code|
	filename = "hyph_#{language_code}_IN.dic"
	url      = "http://git.savannah.gnu.org/cgit/smc/hyphenation.git/plain/#{language_code}_IN/#{filename}"
	system("wget -N -c -P original #{url}")

	lines = IO.readlines("original/#{filename}", '.').join("").
# a few temporary patches - remove double newline at the end of file, remove trailing spaces, remove double "GENERAL RULE" comment in the file
		gsub(/\n\n$/, "\n").gsub(/(\s*)\n/, "\n").
		gsub(/(% GENERAL RULE)\n% GENERAL RULE/, '\1').
# end of temporary patches
		gsub(/UTF-8/, "% These patterns originate from\n%    http://git.savannah.gnu.org/cgit/smc/hyphenation.git/tree/)\n% and have been adapted for hyph-utf8 (for use in TeX).\n%").
		gsub(/% GENERAL RULE/, "\\patterns{\n% GENERAL RULE") + "}\n"

	filename_out = "#{path}/hyph-#{language_code}.tex"
	file_out = File.open(filename_out, "w")
	file_out.puts(lines)
	file_out.close
end
