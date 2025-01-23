#!/usr/bin/env ruby

require_relative 'hyph-utf8'
require_relative 'lib/tex/hyphen'
require_relative 'lib/tex/hyphen/texlive'
include TeX::Hyphen
include TeXLive

# this file generates patterns for pTeX out of the plain ones

# load encodings
encodings_list =
  Dir.glob(File.expand_path(File.join(__dir__, 'data/encodings/*.dat'))).map do |encdat|
    encdat.gsub /^.*\/(.*)\.dat$/, '\1'
end
encodings = Hash.new
encodings_list.each do |encoding_name|
  encodings[encoding_name] = HyphEncoding.new(encoding_name)
end

header = <<-HEADER
%% pTeX-friendly hyphenation patterns
%%
%% language: %s (%s)
%% encoding: %s
%%
%% This file has been auto-generated from hyph-%s.tex
%% with a script [texmf]/scripts/generic/hyph-utf8/generate-ptex-patterns.rb
%% See the original file for details about author, licence etc.
%%
HEADER

print '[1;34mGenerating pTeX patterns[0m for (skipped # reason): '
Language.all.sort.each do |language|
  if language.use_old_patterns_comment || !language.encoding || language.encoding == 'ascii'
    if language.use_old_patterns_comment
      reason = 'legacy patterns'
    else
      reason = sprintf 'encoding: %s', language.encoding.inspect
    end
    print '([0;31m', language.bcp47, '[0m # ', reason, ') '

    next
  else
    encoding = encodings[language.encoding]
  end

  bcp47 = language.bcp47

  print bcp47,  ' '
  File.open(File.join(PATH::PTEX, sprintf('hyph-%s.%s.tex', bcp47, language.encoding)), 'w') do |file_ptex|
    patterns   = language.patterns
    exceptions = language.exceptions

    characters = patterns.join('').gsub(/[.0-9]/,'').unpack('U*').sort.uniq

    if language.encoding != 'ascii' then
      patterns   = encoding.convert_to_escaped_characters(patterns)
      exceptions = encoding.convert_to_escaped_characters(exceptions)
    end

    file_ptex.printf(header, language.babelname, language.bcp47, language.encoding, language.bcp47)

    file_ptex.puts("\\bgroup")
    # setting lccodes for letters
    characters.each do |c|
      if (c == 0x01FD or c == 0x0301) and language.bcp47 == 'la-x-liturgic'
        # skip
      elsif c >= 128 then
        code = encoding.unicode_characters[c].code_enc
        file_ptex.printf("\\lccode\"%02X=\"%02X\n", code, code)
      end
    end
    # patterns
    if patterns.length > 0 then
      file_ptex.puts("\\patterns{\n#{patterns.join("\n")}\n}")
    end
    # exceptions
    if exceptions.length > 0 then
      file_ptex.puts("\\hyphenation{\n#{exceptions.join("\n")}\n}")
    end
    file_ptex.puts("\\egroup")
  end
end
puts
