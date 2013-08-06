require 'tmpdir'
require 'fileutils'
require 'yaml'

Given /^I set up the environment for texhyphen$/ do
  texhyphdir = File.expand_path('../../../../..', __FILE__)
  unless File.file?("#{texhyphdir}/trunk/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-sl.tex")
    puts "Could not the tex-hyphen root."
    exit(-1)
  end
  ENV['TEXINPUTS'] = "#{texhyphdir}/trunk/hyph-utf8/tex/generic//:#{texhyphdir}/trunk/TL/texmf-dist/tex/generic/config:"
end

When /^I make the format for (.*?)$/ do |format|
  @format = format
  @tmpdir = Dir.mktmpdir
  FileUtils.chdir(@tmpdir)
  arg = if format =~ /^xe/ then "-etex" else "" end
  `#{format} -interaction=nonstopmode #{arg} -ini #{format}.ini`
end

Then /^it should make a format file$/ do
  File.file?("#{@format}.fmt").should be_true
  FileUtils.rmtree(@tmpdir)
end
