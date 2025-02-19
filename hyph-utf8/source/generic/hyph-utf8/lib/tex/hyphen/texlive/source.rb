module TeX
  module Hyphen
    module TeXLive
      module Source
        def path(type, file)
          File.join(PATH::HYPHU8, 'patterns', type, file)
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
          return "" if use_old_loader || @bcp47 == 'mn-cyrl-x-lmc'

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

        def pTeX_patterns
          if italic?
            sprintf 'hyph-%s.tex', @bcp47
          elsif encoding
            sprintf 'hyph-%s.%s.tex', @bcp47, encoding
          else
            legacy_patterns
          end
        end

        def list_loader
          # which loader to use
          if @bcp47 == 'mn-cyrl-x-lmc'
            return "file=loadhyph-mn-cyrl-x-lmc.tex \\\n\tluaspecial=\"#{luaspecial}\""
          end
          if @bcp47 == 'grc-x-ibycus'
            # TODO: fix this
            sprintf "file=%s \\\n\tluaspecial=\"disabled:8-bit only\"", loadhyph
          else
            sprintf "file=%s", loadhyph
          end
        end

        def list_run_files
          if use_old_loader
            puts "[1;31mUse_old_loader[0m: [#{@bcp47}]"
          end
          # if ['ar', 'fa', 'he', 'vi', 'grc-x-ibycus'].include? @bcp47 then
          if use_old_loader then
            return [path('tex', "hyph-#{@bcp47}.tex")]
          end
          return [] if use_old_loader

          files = []

          files << File.join(PATH::HYPHU8, 'loadhyph', loadhyph)
          if has_apostrophes?
            files << path('quote', sprintf("hyph-quote-%s.tex", bcp47))
          end

          files << path('tex', sprintf('hyph-%s.tex', bcp47))
          # FIXME That line is awful -- AR 2020-11-22
          if encoding && encoding != "ascii" && !['la-x-classic', 'mk', 'zh-latn-pinyin'].include?( bcp47) then
            files << path('ptex', sprintf('hyph-%s.%s.tex', bcp47, encoding))
          elsif ['cop', 'mk'].include? bcp47 # FIXME That one too!
            files << path('tex-8bit', legacy_patterns)
          end

          # we skip the mongolian language for luatex files
          return files if bcp47 == "mn-cyrl-x-lmc"

          ['pat', 'hyp'].each do |t|
            file = path('txt', sprintf('hyph-%s.%s.txt', bcp47, t))
            files << file if File.exist? File.join('hyph-utf8', file)
          end

          if bcp47 =~ /^sh-/
            # duplicate entries (will be removed later)
            files << path('tex', 'hyph-sr-cyrl.tex')
            ['pat', 'hyp'].each do |t|
              # duplicate entries (will be removed later)
              files << path('txt', sprintf('hyph-sr-cyrl.%s.txt', t))
            end
          end

          # byebug if bcp47 == 'zh-latn-pinyin'
          files
        end

        def package
          extract_metadata
          @package
        end
      end
    end
  end
end
