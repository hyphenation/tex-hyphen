module TeX
  module Hyphen
    module TeXLive
      module Loader

        def unicode_only? # TODO Spec out
          ['cu', 'sa','as','bn','gu','hi','hy','kn','lo','mul-ethi','ml','mr','or','pa','ta','te', 'pi', 'mk'].include? @bcp47
        end

        def string_enc
          (encoding == nil) ? "" : encoding.upcase + " "
        end

        def lcchars
          if isgreek?
            # some catcodes for XeTeX
            return {
              lccode: {
                0x0027 => '\'',
                0x2019 => '’',
                0x02BC => 'ʼ',
                0x1FBD => '᾽',
                0x1FBF => '᾿',
              }
            }
          end

          return { } unless unicode_only?

          default = {
            comment: 'Set \lccode for ZWNJ and ZWJ.',
            lccode: {
              0x200C => false,
              0x200D => false,
            }
          }

          {
            'mul-ethi' => {
              comment: 'Set \lccode for Ethiopian word space.',
              lccode: {
                0x1361 => false,
                0x1362 => false,
              }
            },
            'cu' => {
              comment: 'fix lccodes for some characters (they were recently included in Unicode)',
              lccode: {
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
            },
            'sa' => {
              comment: 'Set \lccode for ZWNJ and ZWJ.',
              lccode: {
                0x200C => false,
                0x200D => "\n% Set \\lccode for KANNADA SIGN JIHVAMULIYA and KANNADA SIGN UPADHMANIYA.",
                0x0CF1 => false,
                0x0CF2 => false,
              }
            },
        }[@bcp47] || default
        end

        def utf8_engine_message
          if serbian?
            'UTF-8 Serbian hyphenation patterns'
          else
            sprintf('UTF-8 %s', message)
          end
        end

        def non_utf8_engine_message
          if unicode_only?
            sprintf('No %s - only for Unicode engines', message)
          else
            @files[:nonutf8] ||= TeXFile.new(@bcp47, :nonutf8)
            sprintf('%s%s', string_enc, @files[:nonutf8].message || message)
          end
        end

        def engine_message(engine)
          if engine == 'UTF-8'
            {
              comment: 'Unicode-aware engine (such as XeTeX or LuaTeX) only sees a single (2-byte) argument',
              message: utf8_engine_message
            }
          else # engine is 8-bit or pTeX
            {
              comment: engine +
                if engine == '8-bit' then " engine (such as TeX or pdfTeX)" else "" end,
              message: non_utf8_engine_message
            }
          end
        end

        def input_8bit_file
          if @bcp47 == 'la-x-liturgic'
            {
              input: [pTeX_patterns]
            }
          elsif use_old_patterns_comment
            # explain why we are still using the old patterns
            {
              comment: use_old_patterns_comment,
              input: [legacy_patterns]
            }
          elsif !italic?
            {
              input: [sprintf('conv-utf8-%s.tex', encoding), sprintf('hyph-%s.tex', @bcp47)]
            }
          else
            {
              input: [sprintf('hyph-%s.tex', @bcp47)]
            }
          end
        end

        def input_utf8_line
          if serbian?
            {
              comment: 'We load both scripts at the same time to simplify usage',
              input: ['hyph-sh-latn.tex', 'hyph-sh-cyrl.tex']
            }
          else
            {
              input: [sprintf('hyph-%s.tex', @bcp47)]
            }
          end
        end

        def format_inputs(specification)
          if specification.is_a? Array
            return specification.map do |hash|
              format_inputs(hash)
            end
          end

          byebug unless specification.is_a? Hash
          comment = specification[:comment]
          message = specification[:message]
          if comment then [sprintf('%% %s', comment)] else [] end +
          if message then [sprintf('\\message{%s}', message)] else [] end +
          (specification[:lccode] || []).map do |code, comment|
            sprintf '\\lccode"%04X="%04X%s', code, code, if comment then sprintf ' %% %s', comment else '' end
          end +
          (specification[:input] || []).map do |input|
            sprintf '\\input %s', input
          end
        end

        def input_line(engine)
          if engine == '8-bit'
            input_8bit_file
          elsif engine == 'pTeX'
            { input: [pTeX_patterns] }
          elsif engine == 'UTF-8'
            input_utf8_line
          end
        end

        def utf8_chunk
          [
            engine_message('UTF-8'),
            # lccodes
            lcchars,
            input_line('UTF-8'),
            if has_apostrophes? then { input: [sprintf('hyph-quote-%s.tex', bcp47)] } end
          ].compact
        end

        def nonutf8_chunk(engine)
          [engine_message(engine), unless unicode_only? then input_line(engine) end].compact
        end

        def loadhyph
          if use_old_loader
            legacy_patterns
          else
            sprintf 'loadhyph-%s.tex', @bcp47.gsub(/^sh-/, 'sr-')
          end
        end
      end
    end
  end
end
