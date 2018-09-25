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
			new language_data
		end
	end

	# TODO self.find

  # TODO Scheduled for removal
  @@texfile = Hash.new
	def readtexfile(code = @code)
		@@texfile[code] ||= File.read(File.join(PATH::TEX, sprintf('hyph-%s.tex', code)))
	end

  # TODO Scheduled for removal
	def exceptions
		@exceptions ||= if readtexfile.superstrip.index('\hyphenation')
		readtexfile.superstrip.gsub(/.*\\hyphenation\s*\{(.*?)\}.*/m,'\1').supersplit
		else
			""
		end
	end

	# TODO Scheduled for removal
	def patterns
		@patterns ||= if @code == 'eo' then
			readtexfile.superstrip.
				gsub(/.*\\patterns\s*\{(.*)\}.*/m,'\1').
				#
				gsub(/\\adj\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e.').
				gsub(/\\nom\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e. \1o. \1oj. \1ojn. \1on.').
				gsub(/\\ver\{(.*?)\}/m,'\1as. \1i. \1is. \1os. \1u. \1us.').
				#
				supersplit
		else
			readtexfile(if ['nb', 'nn'].include? @code then 'no' else @code end).superstrip.
				gsub(/.*\\patterns\s*\{(.*?)\}.*/m,'\1').
				supersplit
		end
	end

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

	# Strictly speaking a misnomer, because grc-x-ibycus should also return true.
	# But useful for a number of apostrophe-related routines
	def isgreek?
	  ['grc', 'el-polyton', 'el-monoton'].include? @code
	end

	def has_apostrophes?
		begin
			!isgreek? && patterns.any? { |p| p =~ /'/ }
		rescue Errno::ENOENT
		  false
		end
	end

	def has_dashes?
		begin
			patterns.any? { |p| p =~ /-/ }
		rescue Errno::ENOENT
			false
		end
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
		def loadhyph
			if use_old_loader
				filename_old_patterns
			else
				sprintf 'loadhyph-%s.tex', @code.gsub(/^sh-/, 'sr-')
			end
		end

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

		def list_run_files
			return [] if use_old_loader

			files = []

			files << File.join(PATH::HYPHU8, 'loadhyph', loadhyph)
			if has_apostrophes?
				files << File.join(PATH::HYPHU8, 'patterns', 'quote', sprintf("hyph-quote-%s.tex", code))
			end

			files << File.join(PATH::HYPHU8, 'patterns', 'tex', sprintf('hyph-%s.tex', code))
			if encoding && encoding != "ascii" then
				files << File.join(PATH::HYPHU8, 'patterns', 'ptex', sprintf('hyph-%s.%s.tex', code, encoding))
			elsif code == "cop"
				files << File.join(PATH::HYPHU8, 'patterns', 'tex-8bit', filename_old_patterns)
			end

			# we skip the mongolian language for luatex files
			return files if code == "mn-cyrl-x-lmc"

			['chr', 'pat', 'hyp', 'lic'].each do |t|
				files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-%s.%s.txt', code, t))
			end

			if code =~ /^sh-/
				# duplicate entries (will be removed later)
				files << File.join(PATH::HYPHU8, 'patterns', 'tex', 'hyph-sr-cyrl.tex')
				['chr', 'pat', 'hyp', 'lic'].each do |t|
					# duplicate entries (will be removed later)
					files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-sr-cyrl.%s.txt', t))
				end
			end

			files
		end
	end
end
