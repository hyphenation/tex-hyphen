require 'yaml'
require 'hydra'
require 'byebug' rescue LoadError

module TeX
  module Hyphen
    class InvalidMetadata < StandardError; end

    class Language
      @@topdir = File.expand_path('../../../../hyph-utf8/tex/generic/hyph-utf8/patterns', __FILE__)
      @@eohmarker = '=' * 42

      def initialize(bcp47 = nil)
        @bcp47 = bcp47
      end

      def self.all
        @@languages ||= Dir.glob(File.join(@@topdir, 'tex', 'hyph-*.tex')).inject [] do |languages, texfile|
          bcp47 = texfile.gsub /^.*\/hyph-(.*)\.tex$/, '\1'
          languages << [bcp47, Language.new(bcp47)] # TODO Load names of files (patterns, exceptions)
        end.to_h
      end

      def self.find_by_bcp47(bcp47)
        all[bcp47]
      end

      def bcp47
        self.class.all
        @bcp47
      end

      def patterns
        @patterns ||= File.read(File.join(@@topdir, 'txt', sprintf('hyph-%s.pat.txt', @bcp47))) if self.class.all[@bcp47]
      end

      def exceptions
        if self.class.all[@bcp47]
          @exceptions ||= File.read(File.join(@@topdir, 'txt', sprintf('hyph-%s.hyp.txt', @bcp47)))
          @hyphenation = @exceptions.split(/\s+/).inject [] do |exceptions, exception|
            exceptions << [exception.gsub('-', ''), exception]
          end.to_h

          # puts @hyphenation
        end
      end

      def hyphenate(word)
        exceptions
        return @hyphenation[word] if @hyphenation[word]
        unless @hydra
          begin
            metadata = extract_metadata
            @hydra = Hydra.new patterns.split, :lax, '', metadata
          rescue InvalidMetadata
            @hydra = Hydra.new patterns.split
          end
        end
        @hydra.showhyphens(word) # FIXME Take exceptions in account!
      end

      def extract_metadata
        header = ""
        File.read(File.join(@@topdir, 'tex', sprintf('hyph-%s.tex', @bcp47))).each_line do |line|
          break if line =~ /\\patterns|#{@@eohmarker}/
          header += line.gsub(/^% /, '').gsub(/%.*/, '')
        end
        begin
          metadata = YAML::load header
          raise InvalidMetadata unless metadata.is_a? Hash
        rescue Psych::SyntaxError
          raise InvalidMetadata
        end

        @name = metadata.dig('language', 'name')
        @lefthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'left')
        @righthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'right')
        licences = metadata.dig('licence')
        raise InvalidMetadata unless licences
        licences = [licences] unless licences.is_a? Array
        @licences = licences.map do |licence|
          next if licence.values == [nil]
          licence.dig('name') || 'custom'
        end.compact
        authors = metadata.dig('authors')
        @authors = if authors
          authors.map do |author|
            author['name']
          end
        else
          nil
        end

        metadata
      end
    end
  end
end
