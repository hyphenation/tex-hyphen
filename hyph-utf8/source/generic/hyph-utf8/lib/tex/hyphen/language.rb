require 'yaml'
require 'hydra'
require 'byebug' unless ENV['RACK_ENV'] == "production"

require_relative 'path'

class String
  def superstrip
    strip.gsub /%.*$/, ''
  end

  def supersplit
    strip.gsub(/\s+/m,"\n").split("\n")
  end

  def safe
    gsub /[\s-]/, ''
  end

  def titlecase
    split.map(&:capitalize).join(' ')
  end
end

module TeX
  module Hyphen
    class InvalidMetadata < StandardError; end
    class NoAuthor < InvalidMetadata; end
    class NoLicence < InvalidMetadata; end

    include PATH

    class Author
      def initialize(name,surname,email,contacted1,contacted2)
        @name       = name
        @surname    = surname
        @email      = email
        # this mostly means if email has been recently checked
        @contacted1 = contacted1
        # this means if we made more cooperation with author,
        # exchanging patches etc.
        @contacted2 = contacted2
      end

      attr_reader :name, :surname, :email

      def self.authors
        @@authors ||= YAML::load File.read File.expand_path 'authors.yml', __dir__
      end

      def self.all
        authors.values
      end

      def self.[] a
        authors[a]
      end
    end

    class Language
      attr_reader :bcp47

      @@eohmarker = '=' * 42

      def babelname
        extract_metadata
        @babelname
      end

      def description
        extract_metadata
        @description
      end

      def use_old_loader
        extract_metadata
        @use_old_loader
      end

      def use_old_patterns_comment
        extract_metadata
        @use_old_patterns_comment
      end

      def legacy_patterns
        extract_metadata
        @legacy_patterns
      end

      def message
        extract_metadata
        @message
      end

      def initialize(bcp47 = nil)
        @bcp47 = bcp47
      end

      def self.languages
        @@languages ||= Dir.glob(File.join(PATH::TEX, 'hyph-*.tex')).inject [] do |languages, texfile|
          bcp47 = texfile.gsub /^.*\/hyph-(.*)\.tex$/, '\1'
          # languages << [bcp47, Language.new(bcp47)]
          languages << [bcp47, nil]
        end.to_h
      end
      @@languages = Language.languages

      def self.all
        @@all ||= languages.map do |bcp47, language|
          next if bcp47 == 'sr-cyrl' # FIXME Remove later
          @@languages[bcp47] ||= Language.new(bcp47)
        end.compact
      end

      def self.find_by_bcp47(bcp47)
        languages[bcp47]
      end

      def private_use?
        )@bcp47[3] == '-' || @bcp47.length == 3 and @bcp47[0] == 'q' and ('a'..'t').include? @bcp47[1]
      end

      # TODO This should probably become “macrolanguage name” or something similar
      # @@displaynames = {
      #   'el' => 'Greek',
      #   'nb' => 'Norwegian',
      #   'nn' => 'Norwegian',
      #   'sh' => 'Serbian',
      # }

      def licences
        extract_metadata unless @licences
        @licences
      end

      def lefthyphenmin
        extract_metadata unless @lefthyphenmin
        @lefthyphenmin
      end

      def righthyphenmin
        extract_metadata unless @righthyphenmin
        @righthyphenmin
      end

      # Strictly speaking a misnomer, because grc-x-ibycus should also return true.
      # But useful for a number of apostrophe-related routines
      def isgreek?
        ['grc', 'el-polyton', 'el-monoton'].include? @bcp47
      end

      def serbian?
        @bcp47 =~ /^sh-/
      end

      def italic?
        ['it', 'pms', 'rm'].include? @bcp47
      end

      def has_apostrophes?
        begin
          !isgreek? && patterns.any? { |p| p =~ /'/ }
        rescue Errno::ENOENT
          false
        end
      end

      def has_hyphens?
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

      def extract_characters # FIXME Turkish and others iİ; check Church Slavonic
        characters = Array.new

        characters_indexes = patterns.join.gsub(/[.0-9]/,'').unpack('U*').sort.uniq
        characters_indexes.each do |c|
          ch = [c].pack('U')
          characters << ch + ch.upcase
          characters << "’’" if ch == "'" && !isgreek?
        end

        characters
      end

      def comments_and_licence # Major TODO extract everything into YAML, and write .yml
        @comments_and_licence ||= readtexfile.gsub(/(.*)\\patterns.*/m,'\1')
      end

      def authors
        extract_metadata unless @authors
        @authors
      end

      def github_link
        sprintf 'https://github.com/hyphenation/tex-hyphen/tree/master/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-%s.tex', @bcp47
      end

      def <=>(other)
        # TODO Remove when practical
        a = self.babelname
        b = other.babelname

        if a == 'serbian' && b == 'serbianc'
          return -1
        elsif a == 'serbianc' && b == 'serbian'
          return 1
        end

        self.bcp47 <=> other.bcp47
      end

      @@texfile = Hash.new
      def readtexfile(bcp47 = @bcp47)
        begin
          @@texfile[bcp47] ||= File.read(File.join(PATH::TEX, sprintf('hyph-%s.tex', bcp47)))
        rescue Errno::ENOENT
          @@texfile[bcp47] = ""
        end
      end

      def patterns
        @patterns ||= if @bcp47 == 'eo' then
          readtexfile.superstrip.
            gsub(/.*\\patterns\s*\{(.*)\}.*/m,'\1').
            #
            gsub(/\\adj\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e.').
            gsub(/\\nom\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e. \1o. \1oj. \1ojn. \1on.').
            gsub(/\\ver\{(.*?)\}/m,'\1as. \1i. \1is. \1os. \1u. \1us.').
            #
            supersplit
        else
          readtexfile(if ['nb', 'nn'].include? @bcp47 then 'no' else @bcp47 end).superstrip.
            gsub(/.*\\patterns\s*\{(.*?)\}.*/m,'\1').
            supersplit
        end
      end

      def exceptions
        unless @exceptions
          if readtexfile.superstrip.index('\hyphenation')
            @exceptions = readtexfile.superstrip.gsub(/.*\\hyphenation\s*\{(.*?)\}.*/m,'\1').supersplit
            if @exceptions != ""
              @hyphenation = @exceptions.inject [] do |exceptions, exception|
                # byebug unless exception
                exceptions << [exception.gsub('-', ''), exception]
              end.to_h
            else
              @hyphenation = { }
            end
          else
            @exceptions = ""
            @hyphenation = { }
          end
        end

        @exceptions
      end

      def hyphenate(word)
        exceptions
        return @hyphenation[word] if @hyphenation[word] # FIXME Better name

        unless @hydra
          begin
            # byebug
            metadata = extract_metadata
            @hydra = Hydra.new patterns, :lax, '', metadata
          rescue InvalidMetadata
            @hydra = Hydra.new patterns
          end
        end
        @hydra.showhyphens(word)
      end

      def extract_metadata
        header = ""
        File.read(File.join(PATH::TEX, sprintf('hyph-%s.tex', @bcp47))).each_line do |line|
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
        @lefthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'left') || metadata.dig('hyphenmins', 'generation', 'left')
        @righthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'right') || metadata.dig('hyphenmins', 'generation', 'right')
        # TODO Something about being in the right module
        @synonyms = metadata.dig('texlive', 'synonyms') || []
        @encoding = metadata.dig('texlive', 'encoding')
        @message = metadata.dig('texlive', 'message')
        @legacy_patterns = metadata.dig('texlive', 'legacy_patterns')
        @use_old_loader = metadata.dig('texlive', 'use_old_loader')
        @use_old_patterns_comment = metadata.dig('texlive', 'use_old_patterns_comment')
        @description = metadata.dig('texlive', 'description')
        @babelname = metadata.dig('texlive', 'babelname')
        @package = metadata.dig('texlive', 'package')
        licences = metadata.dig('licence')
        raise NoLicence unless licences
        licences = [licences] unless licences.is_a? Array
        @licences = licences.map do |licence|
          raise bcp47 if licence.is_a? String
          next if licence.values == [nil]
          licence.dig('name') || 'custom'
        end.compact
        authors = metadata.dig('authors')
        if authors
          @authors = authors.map do |author|
            author['name']
          end
        else
          @authors = nil
          raise NoAuthor.new # FIXME
        end

        # raise NoAuthor unless @authors && @authors.count > 0 # TODO Later ;-) AR 2018-09-13

        metadata
      end
    end

    module TeXLive
    end
  end
end
