# encoding: UTF-8

require 'byebug'

module TeX
  module Hyphen
    class Converter
      def self.scan_line(line)
        m = line.match /^(0x\h{2})\tU\+(\h{4})(?:\t(1?)(?:\t(\w+)))?$/
        return nil unless m

        return m[1].to_i(16), m[2].to_i(16).chr(Encoding::UTF_8), m[3].to_i, m[4]
      end

      def read(conversion)
        @mapping = { }
        File.read(conversion).each_line do |line|
          next if line =~ /^#/

          eightbit, usv = Converter.scan_line line
          @mapping[eightbit] = usv.chr
        end
      end

      def convert(filename)
        raise "Please define the encoding mapping first with #read" unless @mapping
        doconvert = false
        File.open(filename, external_encoding: Encoding::ASCII_8BIT).each_line do |line|
          if line =~ /\\patterns{/
            doconvert = true
            next
          end
          doconvert = false if doconvert && line =~ /}/

          if doconvert
            puts (line.strip.each_byte.map do |byte|
              byebug unless @mapping[byte]
              @mapping[byte]
            end || '').join
          end
        end
      end
    end
  end
end
