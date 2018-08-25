task default: %w[build]

task :build do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-converters.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-pattern-loaders.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-ptex-patterns.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-tl-files.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-plain-patterns.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-webpage.rb"
  system "tools/make_CTAN_zip.sh"
end
