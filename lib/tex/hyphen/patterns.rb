require 'byebug' rescue LoadError

module TeX
  module Hyphen
    class Language
      @@topdir = File.expand_path('../../../../hyph-utf8/tex/generic/hyph-utf8/patterns', __FILE__)

      def initialize(bcp47 = nil)
        @bcp47 = bcp47
      end

      def self.all
        @@languages ||= Dir.glob(File.join(@@topdir, 'txt', 'hyph-*.pat.txt')).inject [] do |languages, txtfile|
          bcp47 = txtfile.gsub /^.*\/hyph-(.*)\.pat\.txt$/, '\1' # TODO Move that to #hyphenate
          languages << [bcp47, Language.new(bcp47)]
        end.to_h
      end

      def self.find_by_bcp47(bcp47)
        all[bcp47]
      end

      def bcp47
        self.class.all
        @bcp47
      end

      def patterns
        self.class.all
        @patterns ||= File.read(File.join(@@topdir, 'txt', sprintf('hyph-%s.pat.txt', @bcp47))) rescue Errno::ENOENT
      end

      def exceptions
        self.class.all
        @exceptions ||= File.read(File.join(@@topdir, 'txt', sprintf('hyph-%s.hyp.txt', @bcp47))) rescue Errno::ENOENT
      end
    end
  end
end
