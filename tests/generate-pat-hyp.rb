#!/usr/bin/env ruby

# Devoted to Taco
#
# generates hyp & pat files with one-pattern-per-line and one-exception-per-line

$package_name="hyph-utf8"

# TODO - make this a bit less hard-coded
$path_tex_patterns = "../#{$package_name}/tex/generic/#{$package_name}/patterns"
$path_pat = "pat"
$path_hyp = "hyp"

Dir.open($path_tex_patterns) do |dir|
	dir.each do |file|
		next unless file =~ /^hyph-(.*)[.]tex$/
		code = $1
		
		filename_tex = "#{$path_tex_patterns}/hyph-#{code}.tex"
		filename_pat = "#{$path_pat}/hyph-#{code}.pat"
		filename_hyp = "#{$path_hyp}/hyph-#{code}.hyp"

		file_content = []
		file_tex = File.open(filename_tex).each_line do |line|
			file_content.push(line.gsub(/%.*/, '').strip)
		end
		file_content = file_content.join(" ").strip.gsub(/(\s)+/, ' ')
	
		if file_content =~ /^\\patterns\s*\{*(.*?)\}\s*(\\hyphenation\s*\{(.*?)\})?/ then
			patterns = $1.strip
			hyphenation = $3
		
			# create a file with patterns
			file_pat = File.open(filename_pat, 'w')
			file_pat.puts patterns.gsub(/\s+/, "\n")
			file_pat.close
		
			# create a file with hyphenation exceptions (if they exist)
			if hyphenation != nil then
				file_hyp = File.open(filename_hyp, 'w')
				file_hyp.puts hyphenation.strip.gsub(/\s+/, "\n")
				file_hyp.close
			end
		else
			puts "something might be wrong with #{code}"
		end
	end
end