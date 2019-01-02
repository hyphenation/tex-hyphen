#!/usr/bin/env ruby

# Validation program for the new YAML headers at the top of TeX hyphenation files.
# Run on an individual file or a directory to get a report of all the errors on the terminal.
# Copyright (c) 2016–2018 Arthur Reutenauer.  MIT licence (https://opensource.org/licenses/MIT)

require 'yaml'
require 'pp'
require 'byebug'

class HeaderValidator
  class WellFormednessError < StandardError # probably not an English word ;-)
  end

  class ValidationError < StandardError
  end

  class InternalError < StandardError
  end

  @@exemptions = ['ar', 'fa', 'grc-x-ibycus']

  @@format = {
    title: {
      mandatory: true,
      type: String,
    },
    copyright: {
      mandatory: true,
      type: String,
    },
    authors: {
       mandatory: true,
       type: Array,
    },
    language: {
      mandatory: true,
      type: {
        name: {
          mandatory: true,
          type: String,
        },
        tag: {
          mandatory: true,
          type: String,
        },
      },
    },
    version: {
      mandatory: false,
      type: String,
    },
    notice: {
      mandatory: true,
      type: String,
    },
    licence: {
      mandatory: true,
      one_or_more: true,
      type: "[Knuth only knows]", # TODO Define
    },
    changes: {
      mandatory: false,
      type: String,
    },
    hyphenmins: {
      mandatory: true,
      type: {
        generation: {
          mandatory: false, # TODO Find way to describe that it *is* mandatory if typesetting absent
          type: {
            left: {
              mandatory: true,
              type: Integer,
            },
            right: {
              mandatory: true,
              type: Integer,
            },
          },
        },
        typesetting: {
          mandatory: false,
          type: {
            left: {
              mandatory: true,
              type: Integer,
            },
            right: {
              mandatory: true,
              type: Integer,
            },
          },
        },
      },
    },
    texlive: {
      mandatory: false,
      type: {
        synonyms: {
          mandatory: false,
          type: Array
        },
        encoding: {
          mandatory: false,
          type: String
        },
        message: {
          mandatory: false,
          type: String
        },
        legacy_patterns: {
          mandatory: false,
          type: String
        },
        use_old_loader: {
          mandatory: false,
          # type: Bool # FIXME
        },
        use_old_patterns_comment: {
          mandatory: false,
          type: String
        },
        description: {
          mandatory: false,
          type: String
        },
        babelname: {
          mandatory: false,
          type: String
        },
        package: {
          mandatory: false,
          type: String
        }
      },
    },
    source: {
      mandatory: false,
      type: String
    },
    known_bugs: {
      mandatory: false,
      type: Array # of strings!
    }
  }

  def initialize
    @errors = { InternalError => [], WellFormednessError => [], ValidationError => [] }
  end

  def parse(filename)
    header = ''
    eohmarker = '=' * 42
    File.read(filename).each_line do |line|
      if line =~ /\\patterns|#{eohmarker}/
        break
      end

      line.gsub!(/^% /, '')
      line.gsub!(/%/, '')
      header += line
    end

    begin
      @metadata = YAML::load(header)
      bcp47 = filename.gsub(/.*hyph-/, '').gsub(/\.tex$/, '')
      raise ValidationError.new("Empty metadata set for language [#{bcp47}]") unless @metadata
    rescue Psych::SyntaxError => err
      raise WellFormednessError.new(err.message)
    end
  end

  def check_mandatory(hash, validator)
    validator.each do |key, validator|
      if validator[:mandatory]
        if !hash.include? key.to_s # Subtle difference between key not present and value is nil :-)
          raise ValidationError.new("Key #{key} missing")
        end
      end
      check_mandatory(hash[key.to_s], validator[:type]) if hash[key.to_s] && validator[:type].respond_to?(:keys)
    end
  end

  def validate(hash, validator)
    hash.each do |key, value|
      raise ValidationError.new("Invalid key #{key} found") if validator[key.to_sym] == nil
      raise ValidationError.new("P & S") if key == 'texlive' && hash['texlive']['package'] && hash['texlive']['description']
      validate(value, validator[key.to_sym][:type]) if value.respond_to?(:keys) && !validator[key.to_sym][:one_or_more]
    end
  end

  def run!(pattfile)
    unless File.file?(pattfile)
      raise InternalError.new("Argument “#{pattfile}” is not a file; this shouldn’t have happened.")
    end
    parse(pattfile)
    check_mandatory(@metadata, @@format)
    validate(@metadata, @@format)
  end

  def runfile(filename)
    begin
      run! filename
    rescue InternalError, WellFormednessError, ValidationError => err
      @errors[err.class] << [filename, err.message]
    end
  end

  def main(args)
    print 'Validating '
    # TODO Sort input file list in alphabetical order of names!
    @mode = 'default'
    arg = args.shift
    if arg == '-m' # Mojca mode
      @mode = 'mojca'
    else
      args = [arg] + args
    end
    while !args.empty?
      arg = args.shift
      unless arg
        puts "Please give me at least one file to validate."
        exit -1
      end

      # byebug
      if File.file? arg
        print 'file ', arg
        runfile(arg)
      elsif Dir.exists? arg
        print 'files in ', arg, ': '
        Dir.foreach(arg) do |filename|
          next if filename == '.' || filename == '..'
          f = File.join(arg, filename)
          print filename.gsub(/^hyph-/, '').gsub(/\.tex$/, ''), ' '
        end
      else
        puts "Argument #{arg} is neither an existing file nor an existing directory; proceeding." unless @mode == 'mojca'
      end

      puts
    end

    unless @mode == 'mojca'
      puts "\nReport on #{arg}:" # FIXME Incorrect if multiple input files given.
      summary = []
      if @errors.inject(0) { |errs, klass| errs + klass.last.count } > 0
        @errors.each do |klass, files|
          next if files.count == 0
          files.each do |file|
            filename = file.first
            message = file.last
            exemption_regexp = Regexp.new '(' + @@exemptions.join('|') + ')'
            skip = klass == ValidationError && message =~ /^Empty metadata set for language \[#{exemption_regexp}\]$/
            summary << "#{filename}: #{klass.name} #{message}" unless skip
          end
        end
      end

      if (exitcode = summary.count) > 0
        puts "There were the following errors with some files:"
        puts summary.join "\n"
        exit exitcode
      else
        puts "No errors were found."
      end
    else
      headings = [:title, :copyright, :notice]
      require './lib/tex/hyphen/language'
      @headings = TeX::Hyphen::Language.all.map { |language| [language, headings.map { |heading| [heading, language.send(heading)] }.to_h] }.to_h
      headings.sort.each do |heading|
        puts heading.capitalize
        puts TeX::Hyphen::Language.all.sort.map { |language| "hyph-#{language.bcp47}.tex: #{@headings[language][heading]}" }.join("\n")
        puts ""
      end
    end
  end
end

validator = HeaderValidator.new
validator.main(ARGV)
