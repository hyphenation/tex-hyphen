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
          return "" if use_old_loader || luaspecial

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
          if luaspecial
            return "file=#{loadhyph} \\\n\tluaspecial=\"#{luaspecial}\""
          else
            sprintf "file=%s", loadhyph
          end
        end

        def list_run_files
          # byebug if @bcp47 == "grc-x-ibycus"
          if use_old_loader
            return [path('tex', "hyph-#{@bcp47}.tex")]
          end

          files = [File.join(PATH::HYPHU8, 'loadhyph', loadhyph)]

          if has_apostrophes?
            files << path('quote', sprintf("hyph-quote-%s.tex", bcp47))
          end

          # byebug if @bcp47 =~ /^grc/
          files << path('tex', sprintf('hyph-%s.tex', bcp47)) # unless @bcp47 == "grc-x-ibycus" # FIXME AR 2025-03-31
          Dir.glob(File.join('hyph-utf8', path('ptex', "hyph-#{bcp47}.*.tex"))) do |file|
            files << file.gsub(/^hyph-utf8\//, '')
          end
          if legacy_patterns
            Dir.glob(File.join('hyph-utf8', path('tex-8bit', legacy_patterns.to_s))) do |file|
              files << file.gsub(/^hyph-utf8\//, '')
            end
          end

          ['pat', 'hyp'].each do |t|
            file = path('txt', sprintf('hyph-%s.%s.txt', bcp47, t))
            files << file if File.exist? File.join('hyph-utf8', file)
          end

          # TODO AR 2026-02-20 Remove after TeX Live freeze?
          if bcp47 =~ /^sh-/
            # duplicate entries (will be removed later)
            files << path('tex', 'hyph-sr-cyrl.tex')
            ['pat', 'hyp'].each do |t|
              # duplicate entries (will be removed later)
              files << path('txt', sprintf('hyph-sr-cyrl.%s.txt', t))
            end
          end

          files
        end

        def package
          extract_metadata unless @package
          @package
        end
      end
    end
  end
end
