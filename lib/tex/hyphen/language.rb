require 'yaml'
require 'hydra'
require 'byebug' unless ENV['RACK_ENV'] == "production"

require_relative '../../../hyph-utf8/source/generic/hyph-utf8/author-data'
require_relative '../../../hyph-utf8/source/generic/hyph-utf8/languages'
require_relative '../../../hyph-utf8/source/generic/hyph-utf8/language-data'

module PATH
  ROOT = File.expand_path('../../../..', __FILE__)

  TeXROOT = File.join(ROOT, 'hyph-utf8')
  TeX_GENERIC = File.join(TeXROOT, 'tex', 'generic')
  PAT = File.join(TeX_GENERIC, 'hyph-utf8', 'patterns')
  TXT = File.join(PAT, 'txt')
  TEX = File.join(PAT, 'tex')
  PTEX = File.join(PAT, 'ptex')
  QUOTE = File.join(PAT, 'quote')

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
      @@eohmarker = '=' * 42

      DELEGATE = [:message, :encoding, :filename_old_patterns, :use_old_loader, :use_old_patterns, :use_old_patterns_comment, :description_l, :list_synonyms, :list_hyphenmins, :synonyms]

      def method_missing(method, *args)
        if DELEGATE.include? method
          # puts @bcp47 unless @old
          # byebug unless @old
          @old.send(method, *args)
        else
          raise NoMethodError.new(method)
        end
      end

      def initialize(bcp47 = nil)
        @bcp47 = bcp47
        # byebug if @bcp47 == 'id'
        if @bcp47 && self.class.languages.include?(@bcp47) && !(@bcp47[0] == 'q' && ('a'..'t').include?(@bcp47[1])) # TODO Method for that
          # puts @bcp47
          @old = OldLanguage.all.select do |language|
            # puts language.code
            language.code == @bcp47
          end.first
          raise "No OldLanguage for #{@bcp47}" unless @old || @bcp47 == 'sr-cyrl'
        end
      end

      def self.languages
        @@languages ||= Dir.glob(File.join(PATH::TEX, 'hyph-*.tex')).inject [] do |languages, texfile|
          bcp47 = texfile.gsub /^.*\/hyph-(.*)\.tex$/, '\1'
          # languages << [bcp47, Language.new(bcp47)]
          languages << [bcp47, nil]
        end.to_h
      end
      @@languages = Language.languages

      # FIXME This is getting messy as hell
      def self.all
        @@all ||= languages.map do |bcp47, language|
          next if bcp47 == 'sr-cyrl' # FIXME Remove later
          # puts bcp47
          # puts bcp47, language
          if language
            l = language
          else
            begin
              l = Language.new bcp47
              l.extract_metadata # FIXME Remove later!
            rescue InvalidMetadata
              # next
              # next unless ['nb', 'nn'].include? bcp47
              next unless ['grc-x-ibycus', 'ar', 'mul-ethi', 'fa'].include? @bcp47
            end
          end

          # puts bcp47, l
          # puts bcp47
          @@languages[bcp47] = l
        end.compact
      end

      def self.all_with_licence
        languages.select do |bcp47, language|
          language ||= (@@languages[bcp47] = Language.new bcp47) unless language
          begin
            licences = language.licences
          rescue InvalidMetadata
            next
          end
          licences.count > 0
        end
      end

      def self.find_by_bcp47(bcp47)
        languages[bcp47]
      end

      def bcp47
        @bcp47
      end

      def name
        # puts @bcp47 unless @name
        extract_metadata unless @name
        @name
      end

      def name_for_loader
        # name.downcase.safe
        @old.name.safe
      end

      def name_for_ptex
        name_for_loader
      end

      def name_for_texlive
        name_for_loader
      end

      def oldname
        @old.name
      end

      @@displaynames = {
        'el' => 'Greek',
        'nb' => 'Norwegian',
        'nn' => 'Norwegian',
        'sh' => 'Serbian',
      }

      def displayname
        extract_metadata unless @name
        @@displaynames[@bcp47.gsub(/-.*$/, '')] || @name
      end

      def description_s
        message
      end

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

      def extract_characters # FIXME Turkish and others iİ
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
        # FIXME Move that to #name
        a = self.name rescue InvalidMetadata
        a = '' if [nil, InvalidMetadata].include? a

        b = other.name rescue InvalidMetadata
        b = '' if [nil, InvalidMetadata].include? b

        if a == b
          self.bcp47 <=> other.bcp47
        else
          a <=> b || -1
        end
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

      def exceptions_old
        # FIXME Same comment as for #patterns
        if self.class.languag[@bcp47]
          @exceptions ||= File.read(File.join(PATH::TXT, sprintf('hyph-%s.hyp.txt', @bcp47)))
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
          # puts metadata
          raise InvalidMetadata unless metadata.is_a? Hash
        rescue Psych::SyntaxError
          raise InvalidMetadata
        end

        @name = metadata.dig('language', 'name')
        @lefthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'left')
        @righthyphenmin = metadata.dig('hyphenmins', 'typesetting', 'right')
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
            filename_old_patterns
          else
            # byebug
            sprintf 'loadhyph-%s.tex', @bcp47.gsub(/^sh-/, 'sr-')
          end
        end

        def list_loader
          # which loader to use
          file = sprintf "file=%s", loadhyph
          return file unless use_old_loader

          if ['ar', 'fa'].include? @bcp47
            file = file + " \\\n\tfile_patterns="
          elsif @bcp47 == 'grc-x-ibycus'
            # TODO: fix this
            file = file + " \\\n\tluaspecial=\"disabled:8-bit only\""
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
            files << File.join(PATH::HYPHU8, 'patterns', 'tex-8bit', filename_old_patterns)
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
      end
    end

    module TeXLive
      class Package
        attr_reader :name

        def initialize(name)
          @name = name
        end

        @@package_mappings = {
          "en-gb"=>"english",
          "en-us"=>"english",
          "nb"=>"norwegian",
          "nn"=>"norwegian",
          "de-1901"=>"german",
          "de-1996"=>"german",
          "de-ch-1901"=>"german",
          "mn-cyrl"=>"mongolian",
          "mn-cyrl-x-lmc"=>"mongolian",
          "el-monoton"=>"greek",
          "el-polyton"=>"greek",
          "grc"=>"ancient greek",
          "grc-x-ibycus"=>"ancient greek",
          "zh-latn-pinyin"=>"chinese",
          "as"=>"indic",
          "bn"=>"indic",
          "gu"=>"indic",
          "hi"=>"indic",
          "kn"=>"indic",
          "ml"=>"indic",
          "mr"=>"indic",
          "or"=>"indic",
          "pa"=>"indic",
          "ta"=>"indic",
          "te"=>"indic",
          "sh-latn"=>"serbian",
          "sh-cyrl"=>"serbian",
          "la"=>"latin",
          "la-x-classic"=>"latin",
          "la-x-liturgic"=>"latin"
        }

        def self.make_mappings
          @@package_names = @@package_mappings.values.uniq.map do |package_name|
            [package_name, new(package_name)]
          end.to_h

          # a hash with the names of TeX Live packages, either individual language names,
          # or an array of languages as the value
          @@packages = Hash.new
          Language.all.each do |language|
            # puts language.bcp47
            package_name = @@package_mappings[language.bcp47]
            next if !package_name && @@package_names.include?(language.oldname)
            package_name ||= language.oldname
            unless package = @@package_names[package_name]
              package = new(package_name) # TODO Remove later
              @@package_names[package_name] = package
            end

            (@@packages[package] ||= []) << language
          end

          @@packages
        end

        @@packages = make_mappings
        def self.all
          @@packages.keys
        end

        # FIXME That’s oh-so-awful
        def description_s
          return 'Hyphenation patterns for Ethiopic scripts' if @name == 'ethiopic'

          if @name == 'arabic'
            leader = '(No) Arabic'
          elsif @name == 'farsi'
            leader = '(No) Persian'
          elsif @name == 'greek'
            leader = 'Modern Greek'
          elsif @name == 'chinese'
            leader = 'Chinese pinyin'
          elsif @name == 'norwegian'
            leader = 'Norwegian Bokmal and Nynorsk'
          else
            leader = @name.titlecase
          end

          shortdesc = sprintf '%s hyphenation patterns', leader

          shortdesc += ' in Cyrillic script' if @name == 'mongolian'

          shortdesc
        end

        #  FIXME This should be at package level from the start
        def description_l
          languages.inject([]) do |description, language|
             description + if language.description_l then language.description_l else [] end
          end
        end

        def languages
          # puts name unless @@packages[self]
          # puts @@packages.keys.map(&:name).sort
          @languages ||= @@packages[self].sort { |a, b| a.bcp47 <=> b.bcp47 } # FIXME Sorting
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
              if language.use_old_patterns and language.filename_old_patterns != "zerohyph.tex" and language.bcp47 != 'cop'
                files << sprintf("tex/generic/hyphen/%s", language.filename_old_patterns)
              end
            end
          end

          files
        end

        def <=>(other)
          # puts 'HELLO'
          # puts name, other.name
          name <=> other.name
        end

        # FIXME Change later
        def self.find(name)
          # puts @@package_names.keys
          # puts @@package_names.values.map(&:name)
          @@package_names[name]
        end
      end
    end
  end
end
