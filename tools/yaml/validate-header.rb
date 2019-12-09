#!/usr/bin/env ruby

# Validation program for the new YAML headers at the top of TeX hyphenation files.
# Run on an individual file or a directory to get a report of all the errors on the terminal.
# Copyright (c) 2016–2017 Arthur Reutenauer.  MIT licence (https://opensource.org/licenses/MIT)

# TODO Add the optional “source” top-level entry

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
    @errors = { }
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
    { title: @metadata['title'], copyright: @metadata['copyright'], notice: @metadata['notice'] }
  end

  def runfile(filename)
    begin
      run! filename
    rescue InternalError, WellFormednessError, ValidationError => err
      (@errors[filename] ||= []) << [err.class, err.message]
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
    @headings = []
    while !args.empty?
      arg = args.shift
      unless arg
        puts "Please give me at least one file to validate."
        exit -1
      end

      if File.file? arg
        print 'file ', arg
        @headings << [File.basename(arg), runfile(arg)]
      elsif Dir.exists? arg
        print 'files in ', arg, ': '
        print(Dir.foreach(arg).map do |filename|
          next if filename == '.' || filename == '..'
          f = File.join(arg, filename)
          @headings << [filename, runfile(f)] unless Dir.exists? f
          filename.gsub(/^hyph-/, '').gsub(/\.tex$/, '')
        end.compact.sort.join ' ')
      else
        puts "Argument #{arg} is neither an existing file nor an existing directory; proceeding." unless @mode == 'mojca'
      end

      puts
    end

    if @mode == 'mojca'
      @headings.sort! { |a, b| a.first <=> b.first }
      [:title, :copyright, :notice].each do |heading|
        puts heading.capitalize
        puts @headings.map { |filedata| "#{filedata.first}: #{filedata.last[heading]}" }.join("\n")
        puts ""
      end
    else
      list = if Dir.exists?(arg) then arg else @headings.map(&:first).join ' ' end
      puts "\nReport on #{list}:"
      summary = []
      @errors.each do |filename, messages|
        messages.each do |file|
          classname = file.first
          message = file.last
          summary << "#{filename}: #{classname} #{message}"
        end
      end

      if (exitcode = summary.count) > 0
        puts "There were the following errors with some files:"
        puts summary.join "\n"
        exit exitcode
      else
        puts "No errors were found."
      end
    end
  end
end

validator = HeaderValidator.new
validator.main(ARGV)
