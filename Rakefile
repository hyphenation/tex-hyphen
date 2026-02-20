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
  task = RSpec::Core::RakeTask.new
  task.pattern = File.join(File.expand_path('../hyph-utf8/source/generic/hyph-utf8', __FILE__), RSpec::Core::RakeTask::DEFAULT_PATTERN)
end

task :converters do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-converters.rb"
end

task :loaders do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-pattern-loaders.rb"
end

task :ptex do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-ptex-patterns.rb"
end

task :texlive do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-tl-files.rb"
end

task :plain do
  ruby "hyph-utf8/source/generic/hyph-utf8/generate-plain-patterns.rb"
end

task :ctan do
  exit if ENV['DRY_RUN'] == "true"
  system "tools/make_CTAN_zip.sh"
end

# TODO: Rubocop
task build: %w[converters loaders ptex texlive plain ctan]
