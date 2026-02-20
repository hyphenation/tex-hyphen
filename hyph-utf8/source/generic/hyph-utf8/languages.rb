# -*- coding: utf-8 -*-
require_relative 'language-data'
require_relative '../../../../lib/tex/hyphen/language'

class OldLanguage
	def initialize(language_hash)
		@use_old_patterns = language_hash["use_old_patterns"]
		@use_old_patterns_comment = language_hash["use_old_patterns_comment"]
		@use_old_loader = language_hash["nohyphenation"]
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

	# def lc_characters
	# 	if @lc_characters == nil
	# 		lc_characters = Hash.new
	# 		p = self.patterns
	# 		p.each do |pattern|
	# 		end
	# 	end
	# 	return @lc_characters
	# end

	attr_reader :use_old_loader, :use_old_patterns_comment, :filename_old_patterns
	attr_reader :code, :name, :message
	attr_reader :description_l

	# Convenience methods related to TeX Live and the .tlpsrc files
	module TeXLive
	end

	include TeXLive
end
