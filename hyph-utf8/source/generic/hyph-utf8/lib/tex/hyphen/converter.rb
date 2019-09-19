# encoding: UTF-8

require 'scanf'

module TeX
  module Hyphen
    class Converter
      def read(conversion)
        @mapping = { }
        File.read(conversion).each_line do |line|
          next if line =~ /^#/

          eightbit, usv = line.scanf "0x%02X\tU+%04X"
          @mapping[eightbit] = usv.chr(Encoding::UTF_8)
        end
      end

      def convert(filename)
        raise "Please define the encoding mapping first with #read" unless @mapping
        doconvert = false
        File.open(filename, external_encoding: Encoding::ASCII_8BIT).each_line do |line|
          doconvert = true if line =~ /\\patterns{/
          doconvert = false if doconvert && line =~ /}/

          if doconvert
            puts (line.strip.each_byte.map do |byte|
              @mapping[byte]
            end || '').join
          end
        end
      end
    end
  end
end
