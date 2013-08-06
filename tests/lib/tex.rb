require 'tmpdir'
require 'fileutils'

class TeXRunner
  attr_reader :dir, :path, :file, :engines, :output, :latex_class, :switches
  attr_accessor :verbose, :mode
  attr_accessor :do_not_cleanup # TODO Spec for that?

  @@formats = { 'xetex' => 'xelatex', 'luatex' => 'lualatex' }
  @@basename = 'feature'
  @@fonts = { 'hebrew' => 'SBL Hebrew', 'cyrillic' => 'PT Serif' }
  @@babel_encodings = { 'hebrew' => 'LHE' }

  def initialize(latex_class = "minimal")
    @latex_class = latex_class || "minimal"
    @dir = Dir.mktmpdir
    @path = File.join(@dir, "#{@@basename}.tex")
    @file = File.open(@path, "w")
    @file.puts "\\documentclass{#{@latex_class}}"
    @engines = @@formats.keys.clone
    @mode = 'nonstop'
    @switches = []
  end

  def self.fonts
    @@fonts
  end

  def self.babel_encodings
    @@babel_encodings
  end

  # TODO Redirect standard error as well
  def verbose?
    verbose
  end

  def has_engine(engine)
    return true if engine == nil
    engines.include?(engine.downcase)
  end

  def set_engine(engine)
    @engines = [engine.downcase]
  end

  def set_engines(engines)
    @engines = engines.map(&:downcase)
  end

  def exclude_engine(engine)
    @engines.delete(engine.downcase)
  end

  def add_switch(switch)
    @switches << switch
  end

  def output
    Hash.new.tap do |o|
      @engines.each do |engine|
        o[engine] = File.join(@dir, engine, "#{@@basename}.pdf")
      end
    end
  end

  def append(content)
    @file.puts content
  end

  def starttyping
    @file.puts "\\begin{document}"
    @file.flush
    @inside_body = true
  end

  def flush_preamble(lines = [])
    raise if @inside_body
    lines.each do |line|
      append(line)
    end
    ensure_inside_body
  end

  def ensure_inside_body
    unless @inside_body
      starttyping
    end
  end

  def stoptyping
    ensure_inside_body
    @file.puts "\\end{document}"
    @file.close
  end

  def source
    stoptyping unless @file.closed?
    File.read(@file)
  end

  def has_already_run
    File.file?(output.values.first.gsub(/\.pdf$/, '.log'))
  end

  def run(count = 1)
  # def run(count = 1, params = { })
    stoptyping unless @file.closed?
    begin
      @origdir = FileUtils.getwd
    rescue Errno::ENOENT # Should not happen, but it does # TODO Audit for directories disappearing
      @origdir = ENV['HOME']
    end
    FileUtils.chdir(@dir)

    ENV['max_print_line'] = "2048"
    Hash.new.tap do |result|
      @engines.each do |engine|
        FileUtils.mkdir(engine) unless File.directory?(engine)
        FileUtils.chdir(engine)
        count.times do
          call = "#{@@formats[engine]} #{@switches.join(' ')} -interaction=#{@mode}mode #{@path}"
          # TODO?  Or return this as status if failure
          # call = "#{@@formats[engine]} -interaction=#{@mode}mode #{@path} 2>/dev/null"
          if @mode == 'errorstop' || verbose? # TODO Spec this out
            system(call)
            # out = params[:out]
            # if out
            #   spawn(call, :out => out)
            # else
            #   spawn(call)
            # end
          else
            `#{call}`
            # TODO Use threads
          end
        end
        FileUtils.chdir('..')
        result[engine] = ($?.exitstatus == 0) if $? # TODO and over all runs
      end
    end

    # TODO: Collect status in a variable, so that we can retrieve it
    # later on without running
  end

  def warnings(regexp = nil)
    errors_or_warnings(/Package .* Warning/, regexp)
  end

  def package_errors(regexp = nil)
    errors_or_warnings(/Package .* Error/, regexp)
  end

  def errors
    errors_or_warnings(/^!/)
  end

  def errors_or_warnings(regexp, message_regexp = nil)
    run unless has_already_run

    errors = { }

    output.each do |engine, pdf|
      append = false
      errors[engine] = []

      log = pdf.gsub(/\.pdf$/, '.log')
      next unless File.file?(log)
      logfile = File.open(log, 'r')
      logfile.each_line do |line|
        if append
          err = errors[engine].pop
          errors[engine] << err + "\n" + line
          append = false
        end

        if line =~ regexp # TODO Catch invalid UTF-8 errors
          if message_regexp
            errors[engine] << line.strip if line =~ /#{regexp}.*#{message_regexp}/
          else
            errors[engine] << line.strip
          end
          append = true
        end
      end
      logfile.close
    end

    errors = errors.values.first if errors.values.uniq.count == 1

    errors
  end

  def value(control_sequence)
  # FIXME remove that
    tweak_end_document
    append "\\makeatletter\\show\\#{control_sequence}"
    show_things
  end

  def lua_value(luacode)
    tweak_end_document
    append "\\directlua{"
    append "f = io.open('#{File.join(@dir, 'luaout.txt')}', 'w')"
    append "local value = #{luacode}"
    append "f:write(tostring(value))"
    append "f:close()"
    append "}"
    run
    File.read(File.join(@dir, 'luaout.txt'))
  end

  # TODO This is obviously awful.  Refactor when I can.
  def tweak_end_document
    if @file.closed?
      tex_source = File.read(path)
      tex_source.gsub!(/\\end{document}/m, '')
      @engines.each do |engine|
        FileUtils.rm_f(File.join(@dir, engine, @@basename + '.log'))
      end
      @file = File.open(path, 'w')
      @file.write(tex_source)
   end

  end

  def showthe(variable)
    append "\\showthe\\#{variable}"
    show_things
  end

  def show_things
    run unless has_already_run

    values = { }

    append = false
    output.each do |engine, pdf|
      log = pdf.gsub(/\.pdf$/, '.log')
      next unless File.file?(log)
      logfile = File.open(log, 'r')
      logfile.each_line do |line|
        if line =~ /^l\.\d/
          append = false
        end

        values[engine] += "\n#{line}" if append

        if line =~ /^> (.*)$/
          values[engine] = $1.strip
          append = true
        end
      end
      logfile.close
    end

    if values.values.uniq.count == 1
      values = values.values.first
    end

    values
  end

  def aux
    byproduct('aux')
  end

  def log
    byproduct('log')
  end

  def grep(regexp, ext = 'log')
    lineno = 0
    matching_lines = []
    byproduct(ext).each_line do |line|
      lineno += 1 # TODO Better formatting
      matching_lines << "#{lineno}:#{line}" if line =~ regexp
    end

    matching_lines
  end

  def byproduct(ext)
    run unless has_already_run
    companion_file = output.values.first.gsub(/pdf$/, ext)
    File.read(companion_file)
  end

  def pdftotext
    run unless has_already_run
    output.each_value do |pdf|
      `pdftotext -layout -enc UTF-8 #{pdf}`
    end
  end

  def text(engine = nil)
    set_engine(engine) if engine
    pdftotext
    texts = { }
    output.keys.each do |engine|
      ff = File.join(@dir, engine, "#{@@basename}.txt")
      texts[engine] = if File.file?(ff)
        File.read(ff).strip
      else
        ""
      end
    end

    texts
  end

  def cleanup
    if @origdir
      FileUtils.chdir(@origdir)
    else
      FileUtils.chdir(ENV['HOME'])
    end

    FileUtils.rmtree(@dir)
  end
end
