# encoding: UTF-8

Given /^I am( not)? testing (.*?)$/ do |not_word, engine|
  # TODO Check that engine actually exists somewhere.
  @tex = TeXRunner.new(@class_name) unless @tex
  engines = engine.split(" and ")
  if not_word
    engines.each { |engine| @tex.exclude_engine(engine) }
  else
    @tex.set_engines(engines)
  end
end

Given /^the main language is (.*?)(?: with (.*))?$/ do |language, options|
  `kpsewhich gloss-#{language.downcase}.ldf`.should be_true
  $?.exitstatus.should == 0
  step "I use package polyglossia"
  opts = if options then "[#{options.split(/\s+and\s+/).join(',')}]" else "" end
  @tex.append "\\setmainlanguage#{opts.downcase}{#{language.downcase}}"
end

Given /^I use package (.*?)(?: with (.*))?$/ do |package, options|
  `kpsewhich #{package.downcase}.sty`
  $?.exitstatus.should == 0
  @tex = TeXRunner.new(@class_name) unless @tex
  opts = if options then "[#{options.split(/\s+and\s+/).join(',')}]" else "" end
  @tex.append "\\usepackage#{opts.downcase}{#{package.downcase}}"
end

Given /^I state (.*)$/ do |statement|
  # TODO Call inside_body? when it exists
  @tex.append statement
end

When /^I set "(.*?)"( in a very narrow paragraph)?$/ do |text, narrow|
  @tex.ensure_inside_body
  @tex.append "\\begin{minipage}{1sp}" if narrow
  @tex.append "\\hskip1sp" if narrow
  @tex.append "\\lccode\"2019=\"2019" if narrow
  @tex.append text
  @tex.append "\\end{minipage}" if narrow
end

Then /^I should see ("|\/)(.*)("|\/)(?: with (.*?))?$/ do |od, expected, cd, tested_engine|
  def massage_output(output)
    ret = output.gsub(/-\n/m, '-').gsub(/\n/m, ' ').gsub(/\u202A|\u202B|\u202C/, '').gsub(/\uFB00/, 'ff')
    ret.gsub!(/[,'"]/, '') if @strip_punct
    ret
  end
  
  if od == '/'
    expected_result = /#{expected}/
  else
    expected_result = expected
  end

  raise "Testing engine that has not been requested in Given step." unless @tex.has_engine(tested_engine)
  results = @tex.text(tested_engine)

  results.each do |engine, text|
    results[engine] = massage_output(text)
  end
  results.should equal_or_match_for_all_values expected_result

  @tex.cleanup
end
