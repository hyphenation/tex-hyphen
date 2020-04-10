require_relative 'texlive/source'
require_relative 'texlive/loader'
require_relative 'texlive/package'

module TeX
  module Hyphen
    module TeXLive
      def synonyms
        delegate(:synonyms)
      end

      def delegate(method)
        # byebug
        # puts "called class = #{self.class}"
        if self.class == Language
        @files[:utf8] ||= TeXFile.new(@bcp47, :utf8)
        @files[:utf8].send(method)
        elsif self.class == TeXFile
        # byebug
        variable = instance_variable_get(:"@#{method}")
        extract_metadata unless variable
        instance_variable_get(:"@#{method}")
        end
      end

      def encoding
        delegate(:encoding)
      end

      include Source
      include Loader
    end
  end

      class TeXFile
      module TeXLive
      def synonyms
      end
      end

      class TeXFile
      def encoding
        extract_metadata unless @encoding
        @encoding
      end
      end
      end
end
