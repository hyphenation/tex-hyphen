module TeX
  module Hyphen
    module TeXLive
      class Package
        attr_reader :name

        @@metadata = YAML::load File.read File.expand_path '../packages.yml', __dir__

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
          override = @@metadata.dig(@name, 'shortdesc_override')
          return override if override

          leader = @@metadata.dig(@name, 'shortdesc') || @name.titlecase
          sprintf '%s hyphenation patterns', leader
        end

        #  FIXME This should be at package level from the start
        def description
          languages.map do |language|
             language.description || ''
          end.join "\n"
        end

        def has_dependency?
          @@metadata.dig(name, 'dependency')
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

          if special = @@metadata.dig(name, type)
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
