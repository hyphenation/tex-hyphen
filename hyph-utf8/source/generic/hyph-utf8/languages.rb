# -*- coding: utf-8 -*-
require_relative 'language-data'
require_relative '../../../../lib/tex/hyphen/language'

class OldLanguage
	def initialize(language_hash)
		@use_old_patterns = language_hash["use_old_patterns"]
		@use_old_patterns_comment = language_hash["use_old_patterns_comment"]
		@use_old_loader = language_hash["use_old_loader"]
		@filename_old_patterns = language_hash["filename_old_patterns"]
		@filename_old_patterns_other = language_hash["filename_old_patterns_other"]
		@code = language_hash["code"]
		@name = language_hash["name"]
		@synonyms = language_hash["synonyms"]
		@hyphenmin = language_hash["hyphenmin"]
		@encoding = language_hash["encoding"]
		@message = language_hash["message"]

		@description_l = language_hash["description_l"]
		@version       = language_hash["version"]

		@licence = language_hash["licence"]
		@authors = language_hash["authors"]

		@synonyms = [] unless @synonyms
	end

	def <=>(other)
	  code <=> other.code
	end

	def self.all
		@@languages ||= @@language_data.map do |language_data|
			next if language_data['code'] == 'sr-cyrl'
			new language_data
		end.compact
	end

	# TODO self.find

	def get_comments_and_licence
		@comments_and_licence ||= readtexfile.gsub(/(.*)\\patterns.*/m,'\1')
	end

	# def lc_characters
	# 	if @lc_characters == nil
	# 		lc_characters = Hash.new
	# 		p = self.patterns
	# 		p.each do |pattern|
	# 		end
	# 	end
	# 	return @lc_characters
	# end

	attr_reader :use_old_loader, :use_old_patterns, :use_old_patterns_comment, :filename_old_patterns
	attr_reader :code, :name, :synonyms, :hyphenmin, :encoding, :message
	attr_reader :description_l, :version
	attr_reader :licence, :authors

	# def message
	# 	@name.titlecase + ' hyphenation patterns'
	# end

	def description_s
		@message
	end

	def extract_apostrophes
		plain, with_apostrophe = Array.new, nil

		patterns.each do |pattern|
			plain << pattern
			if pattern =~ /'/ && !isgreek?
				pattern_with_apostrophe = pattern.gsub(/'/,"’")
				plain << pattern_with_apostrophe
				(with_apostrophe ||= []) << pattern_with_apostrophe
			end
		end

		{ plain: plain, with_apostrophe: with_apostrophe }
	end

	def extract_characters
		characters = Array.new

		characters_indexes = patterns.join.gsub(/[.0-9]/,'').unpack('U*').sort.uniq
		characters_indexes.each do |c|
			ch = [c].pack('U')
			characters << ch + Unicode.upcase(ch)
			characters << "’’" if ch == "'" && !isgreek?
		end

		characters
	end

	# Convenience methods related to TeX Live and the .tlpsrc files
	module TeXLive
		# ext: 'pat' or 'hyp'
		# filetype: 'patterns' or 'exceptions'
		def plain_text_line(ext, filetype) # TODO Figure out if we will sr-cyrl to be generated again
			return "" if ['ar', 'fa', 'grc-x-ibycus', 'mn-cyrl-x-lmc'].include? @code

			if @code =~ /^sh-/
				# TODO Warning AR 2018-09-12
				filename = sprintf 'hyph-sh-latn.%s.txt,hyph-sh-cyrl.%s.txt', ext, ext
			else
				filename = sprintf 'hyph-%s.%s.txt', @code, ext
				filepath = File.join(PATH::TXT, filename)
				# check for existence of file and that it’s not empty
				unless File.file?(filepath) && File.read(filepath).length > 0
					# if the file we were looking for was a pattern file, something’s wrong
					if ext == 'pat'
						raise sprintf("There is some problem with plain patterns for language [%s]!!!", @code)
					else # the file is simply an exception file and we’re happy
						filename = '' # And we return and empty file name after all
					end
				end
			end

			sprintf "file_%s=%s", filetype, filename
		end

		def exceptions_line
			plain_text_line('hyp', 'exceptions')
		end

		def patterns_line
			plain_text_line('pat', 'patterns')
		end

		def list_synonyms
			# synonyms
			if synonyms && synonyms.length > 0
				sprintf " synonyms=%s", synonyms.join(',')
			else
				''
			end
		end

		def list_hyphenmins
			# lefthyphenmin/righthyphenmin
			lmin = (hyphenmin || [])[0]
			rmin = (hyphenmin || [])[1]
			sprintf "lefthyphenmin=%s \\\n\trighthyphenmin=%s", lmin, rmin
		end

		def list_loader
			# which loader to use
			file = sprintf "file=%s", loadhyph
			return file unless use_old_loader

			if ['ar', 'fa'].include? code
				file = file + " \\\n\tfile_patterns="
			elsif code == 'grc-x-ibycus'
				# TODO: fix this
				file = file + " \\\n\tluaspecial=\"disabled:8-bit only\""
			end
		end
	end

	include TeXLive
end
