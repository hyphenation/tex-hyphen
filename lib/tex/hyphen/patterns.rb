module TeX
  module Hyphen
    class Patterns
      @@texfiles = File.expand_path('../../../../hyph-utf8/tex/generic/hyph-utf8/patterns/tex', __FILE__)
      def initialize
        @texfiles = Dir.glob(File.join(@@texfiles, 'hyph-*.tex')).map do |texfile|
          texfile.gsub /^.*\//, ''
        end
      end
    end
  end
end
