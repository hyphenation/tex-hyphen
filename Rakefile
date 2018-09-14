if ENV['RACK_ENV'] == "production"
  task default: %w[build]
else
  require 'rspec/core/rake_task'
  task default: %w[validate spec build]
end

task :validate do
  ruby "tools/yaml/validate-header.rb hyph-utf8/tex/generic/hyph-utf8/patterns/tex"
end

task :spec do
  RSpec::Core::RakeTask.new
end

# TODO: Rubocop
task :build do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-converters.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-pattern-loaders.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-ptex-patterns.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-tl-files.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-plain-patterns.rb"
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-webpage.rb"
  system "tools/make_CTAN_zip.sh"
end
