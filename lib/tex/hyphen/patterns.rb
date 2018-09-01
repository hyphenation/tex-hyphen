module TeX
  module Hyphen
    class Patterns
      @@topdir = File.expand_path('../../../../hyph-utf8/tex/generic/hyph-utf8/patterns', __FILE__)
      def initialize
        @texfiles = Dir.glob(File.join(@@topdir, 'tex', 'hyph-*.tex')).map do |texfile|
          texfile.gsub /^.*\//, ''
        end
        @txtfiles = Dir.glob(File.join(@@topdir, 'txt', 'hyph-*.pat.txt')).map do |txtfile|
          txtfile.gsub /^.*\/hyph-(.*)\.pat\.txt/, ''
        end
      end
    end

    class Language
      def self.all
        @@languages ||= Dir.glob(File.join(Patterns.class_variable_get(:@@topdir), 'txt', 'hyph-*.pat.txt')).map do |txtfile|
          txtfile.gsub /^.*\/hyph-(.*)\.pat\.txt$/, '\1'
        end.sort
      end
    end
  end
end
