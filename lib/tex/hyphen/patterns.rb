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
        @@languages ||= Dir.glob(File.join(@@topdir, 'txt', 'hyph-*.pat.txt')).inject [] do |languages, txtfile|
          bcp47 = txtfile.gsub /^.*\/hyph-(.*)\.pat\.txt$/, '\1' # TODO Move that to #hyphenate
          languages << [bcp47, Language.new(bcp47)]
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
        @exceptions ||= File.read(File.join(@@topdir, 'txt', sprintf('hyph-%s.hyp.txt', @bcp47))) rescue Errno::ENOENT if self.class.all[@bcp47]
      end

      def hyphenate(word)
        @hydra ||= @hydra = Hydra.new patterns.split
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
        rescue Psych::SyntaxError
          raise InvalidMetadata
        end

        @name = metadata.dig('language', 'name')
        @lefthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'left')
        @righthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'right')
        if licences = metadata.dig('licence')
          licences = [licences] unless licences.is_a? Enumerable
          @licences = licences.map { |licence| licence.dig('name') }.compact
        end

        metadata
      end
    end
  end
end
