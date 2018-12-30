Gem::Specification.new do |s|
  s.name = 'tex-hyphen-language'
  s.version = '0.11.2'
  s.date = '2018-12-30'
  s.summary = 'TeX hyphenation patterns as a gem'
  s.description = 'Hyphenation patterns for Ruby, as used by the TeX typesetting system.'
  s.authors = ['Mojca Miklavec', 'Arthur Reutenauer']
  s.email = "info@hyphenation.org"
  s.files = ['hyph-utf8/source/generic/hyph-utf8/spec/tex/hyphen/language_spec.rb'] +
    Dir.glob('hyph-utf8/source/generic/hyph-utf8/lib/tex/hyphen/*') +
    Dir.glob('hyph-utf8/source/generic/hyph-utf8/lib/tex/hyphen/texlive/*') +
    Dir.glob('hyph-utf8/tex/generic/hyph-utf8/patterns/tex/*')
  s.homepage = 'http://www.hyphenation.org/tex'
  s.add_dependency 'hydra'
end
