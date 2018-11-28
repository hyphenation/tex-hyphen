require 'yaml'
require 'hydra'
require 'byebug' unless ENV['RACK_ENV'] == "production"

require_relative 'author-data'

module PATH
  ROOT = File.expand_path('../../../../../../../..', __FILE__)

  TeXROOT = File.join(ROOT, 'hyph-utf8')
  TeX_GENERIC = File.join(TeXROOT, 'tex', 'generic')
  PAT = File.join(TeX_GENERIC, 'hyph-utf8', 'patterns')
  TXT = File.join(PAT, 'txt')
  TEX = File.join(PAT, 'tex')
  PTEX = File.join(PAT, 'ptex')
  QUOTE = File.join(PAT, 'quote')
  LOADER = File.join(TeX_GENERIC, 'hyph-utf8', 'loadhyph')

  SUPPORT = File.join(TeXROOT, '%s', 'generic', 'hyph-utf8', 'languages', '*')

  HYPHU8 = File.join('tex', 'generic', 'hyph-utf8')

  TL = File.join(ROOT, 'TL')
  LANGUAGE_DAT = File.join(PATH::TL, 'texmf-dist', 'tex', 'generic', 'config')
  # hyphen-foo.tlpsrc for TeX Live
  TLPSRC = File.join(PATH::TL, 'tlpkg', 'tlpsrc')
end

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
        @@authors ||= @@author_data.map do |id, details|
          author = Author.new(details[0], details[1], details[2], details[3], details[4])
          [id, author]
        end.to_h
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

      def unicode_only? # TODO Spec out
        ['cu', 'sa','as','bn','gu','hi','hy','kn','lo','mul-ethi','ml','mr','or','pa','ta','te', 'pi'].include? @bcp47
      end

      def lcchars
        return { } unless unicode_only?

        case @bcp47
        when 'mul-ethi'
          {
            comment: 'Set \lccode for Ethiopian word space.',
            0x1361 => false,
            0x1362 => false,
          }
        when 'cu'
          {
            comment: 'fix lccodes for some characters (they were recently included in Unicode)',
            0x1C82 => 'sharp o in lowercase "uk"',
            0x1DF6 => false,
            0x1DF7 => false,
            0x1DF8 => false,
            0x1DF9 => false,
            0xA69E => false,
            0x1C86 => false,
            0xA67E => false,
            0xFE2E => false,
            0xFE2F => false,
          }
        when 'sa'
          {
            comment: 'Set \lccode for ZWNJ and ZWJ.',
            0x200C => false,
            0x200D => "\n    % Set \\lccode for KANNADA SIGN JIHVAMULIYA and KANNADA SIGN UPADHMANIYA.",
            0x0CF1 => false,
            0x0CF2 => false,
          }
        else
          {
            comment: 'Set \lccode for ZWNJ and ZWJ.',
            0x200C => false,
            0x200D => false,
          }
        end
      end

      def print_lcchars(file)
        # some catcodes for XeTeX
        if isgreek?
          file.puts("    \\lccode`'=`'\\lccode`’=`’\\lccode`ʼ=`ʼ\\lccode`᾽=`᾽\\lccode`᾿=`᾿")
          return
        end

        chars = lcchars
        if chars.count > 0
          file.printf "    %% %s\n", chars.delete(:comment)
          chars.each do |code, comment|
            file.print '    '
            file.printf '\lccode"%04X="%04X', code, code
            file.printf ' %% %s', comment if comment
            file.puts
          end
        end
      end

      def print_engine_message(file, utf8 = false)
        comment_engine_utf8 = "% Unicode-aware engine (such as XeTeX or LuaTeX) only sees a single (2-byte) argument"
        if utf8 && serbian?
          file.puts "    #{comment_engine_utf8}"
          file.puts "    \\message{UTF-8 Serbian hyphenation patterns}"
          file.puts "    % We load both scripts at the same time to simplify usage"
        else
          file.puts "    #{comment_engine_utf8}"
          file.puts "    \\message{UTF-8 #{message}}"
        end
      end

      def print_input_line(file, utf8 = false)
        if utf8 && serbian?
          file.puts "    \\input hyph-sh-latn.tex"
          file.puts "    \\input hyph-sh-cyrl.tex"
        else
          file.puts "    \\input hyph-#{@bcp47}.tex"
        end
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
        @bcp47.length == 3 and @bcp47[0] == 'q' and ('a'..'t').include? @bcp47[1]
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

      module TeXLive
        def synonyms
          extract_metadata unless @synonyms
          @synonyms
        end

        def encoding
          extract_metadata unless @encoding
          @encoding
        end

        def list_synonyms
          if synonyms && synonyms.length > 0
            sprintf " synonyms=%s", synonyms.join(',')
          else
            ''
          end
        end

        def list_hyphenmins
          lmin = lefthyphenmin
          rmin = righthyphenmin
          sprintf "lefthyphenmin=%s \\\n\trighthyphenmin=%s", lmin, rmin
        end

        # ext: 'pat' or 'hyp'
        # filetype: 'patterns' or 'exceptions'
        def plain_text_line(ext, filetype) # TODO Figure out if we will sr-cyrl to be generated again
          return "" if ['ar', 'fa', 'grc-x-ibycus', 'mn-cyrl-x-lmc'].include? @bcp47

          if @bcp47 =~ /^sh-/
            # TODO Warning AR 2018-09-12
            filename = sprintf 'hyph-sh-latn.%s.txt,hyph-sh-cyrl.%s.txt', ext, ext
          else
            filename = sprintf 'hyph-%s.%s.txt', @bcp47, ext
            filepath = File.join(PATH::TXT, filename)
            # check for existence of file and that it’s not empty
            unless File.file?(filepath) && File.read(filepath).length > 0
              # if the file we were looking for was a pattern file, something’s wrong
              if ext == 'pat'
                raise sprintf("There is some problem with plain patterns for language [%s]!!!", @bcp47)
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


        def loadhyph
          if use_old_loader
            legacy_patterns
          else
            sprintf 'loadhyph-%s.tex', @bcp47.gsub(/^sh-/, 'sr-')
          end
        end

        def list_loader
          # which loader to use
          if ['ar', 'fa'].include? @bcp47
            sprintf "file=%s \\\n\tfile_patterns=", loadhyph
          elsif @bcp47 == 'grc-x-ibycus'
            # TODO: fix this
            sprintf "file=%s \\\n\tluaspecial=\"disabled:8-bit only\"", loadhyph
          else
            sprintf "file=%s", loadhyph
          end
        end

        def list_run_files
          return [] if use_old_loader

          files = []

          files << File.join(PATH::HYPHU8, 'loadhyph', loadhyph)
          if has_apostrophes?
            files << File.join(PATH::HYPHU8, 'patterns', 'quote', sprintf("hyph-quote-%s.tex", bcp47))
          end

          files << File.join(PATH::HYPHU8, 'patterns', 'tex', sprintf('hyph-%s.tex', bcp47))
          if encoding && encoding != "ascii" then
            files << File.join(PATH::HYPHU8, 'patterns', 'ptex', sprintf('hyph-%s.%s.tex', bcp47, encoding))
          elsif bcp47 == "cop"
            files << File.join(PATH::HYPHU8, 'patterns', 'tex-8bit', legacy_patterns)
          end

          # we skip the mongolian language for luatex files
          return files if bcp47 == "mn-cyrl-x-lmc"

          ['chr', 'pat', 'hyp', 'lic'].each do |t|
            files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-%s.%s.txt', bcp47, t))
          end

          if bcp47 =~ /^sh-/
            # duplicate entries (will be removed later)
            files << File.join(PATH::HYPHU8, 'patterns', 'tex', 'hyph-sr-cyrl.tex')
            ['chr', 'pat', 'hyp', 'lic'].each do |t|
              # duplicate entries (will be removed later)
              files << File.join(PATH::HYPHU8, 'patterns', 'txt', sprintf('hyph-sr-cyrl.%s.txt', t))
            end
          end

          files
        end

        def package
          extract_metadata
          @package
        end
      end
    end

    module TeXLive
      class Package
        attr_reader :name

        def initialize(name)
          @name = name
          @languages = []
        end

        def add_language(language)
          @languages << language
        end

        def languages
          @languages.sort
        end

        def self.packages
          # a hash with the names of TeX Live packages, either individual language names,
          # or an array of languages as the value
          @@packages ||= Language.all.inject(Hash.new) do |packages, language|
            # include Language::TeXLive
            if name = language.package || language.babelname
              package = packages[name] || Package.new(name)
              package.add_language language
              packages[name] = package
            end

            packages
          end
        end

        def self.all
          packages.values
        end

        # FIXME That’s oh-so-awful
        def description_s
          return 'Hyphenation patterns for Ethiopic scripts' if @name == 'ethiopic'

          leader = case @name
          when 'arabic'
            '(No) Arabic'
          when 'farsi'
            '(No) Persian'
          when 'greek'
            'Modern Greek'
          when 'chinese'
            'Chinese pinyin'
          when 'norwegian'
            'Norwegian Bokmal and Nynorsk'
          when 'churchslavonic'
            'Church Slavonic'
          when 'uppersorbian'
            'Upper Sorbian'
          else
            @name.titlecase
          end

          shortdesc = sprintf '%s hyphenation patterns', leader
          shortdesc += ' in Cyrillic script' if @name == 'mongolian'

          shortdesc
        end

        #  FIXME This should be at package level from the start
        def description
          languages.map do |language|
             language.description || ''
          end.join "\n"
        end

        def has_dependency?
          {
            "german" => "dehyph",
            # for Russian and Ukrainian (until we implement the new functionality at least)
            "russian" => "ruhyphen",
            "ukrainian" => "ukrhyph",
          }[name]
        end

        def list_dependencies
          dependencies = [
            "depend hyphen-base",
            "depend hyph-utf8",
          ]

          # external dependencies
          if dependency = has_dependency?
            dependencies << sprintf("depend %s", dependency)
          end

          dependencies
        end

        @@special_support = {
          'doc' => {
            'greek' => 'doc/generic/elhyphen',
            'hungarian' => 'doc/generic/huhyphen',
          }
        }

        def list_support_files(type)
          # Cache directory contents
          (@dirlist ||= { })[type] ||= Dir.glob(sprintf(PATH::SUPPORT, type)).select do |file|
            File.directory?(file)
          end.map do |dir|
            dir.gsub /^.*\//, ''
          end

          files = (languages.map(&:bcp47) & @dirlist[type]).map do |bcp47|
            sprintf("%s/generic/hyph-utf8/languages/%s", type, bcp47)
          end

          if special = @@special_support.dig(type, name)
            files << special
          end

          files
        end

        def list_run_files
          files = []
          files << "tex/generic/hyph-utf8/patterns/tex/hyph-no.tex" if name == "norwegian"

          files = languages.inject(files) do |files, language|
            files + language.list_run_files
          end

          unless has_dependency?
            languages.each do |language|
              if language.use_old_patterns_comment and language.legacy_patterns != "zerohyph.tex" and language.bcp47 != 'cop'
                files << sprintf("tex/generic/hyphen/%s", language.legacy_patterns)
              end
            end
          end

          files
        end

        def <=>(other)
          name <=> other.name
        end

        # TODO Spec out
        def self.find(name)
          packages[name]
        end
      end
    end
  end
end
