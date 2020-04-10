module TeX
  module Hyphen
    module PATH
      ROOT = File.expand_path(File.join('..', '..', '..', '..', '..', '..', '..', '..'), __FILE__)

      TeXROOT = File.join(ROOT, 'hyph-utf8')
      TeX_GENERIC = File.join(TeXROOT, 'tex', 'generic')
      PAT = File.join(TeX_GENERIC, 'hyph-utf8', 'patterns')
      TXT = File.join(PAT, 'txt')
      TEX = File.join(PAT, 'tex')
      TEX8BIT = File.join(PAT, 'tex-8bit')
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
  end
end
