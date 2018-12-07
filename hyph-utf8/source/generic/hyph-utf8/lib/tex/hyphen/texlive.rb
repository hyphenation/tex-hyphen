require_relative 'texlive/source'

module TeX
  module Hyphen
    module TeXLive
      def synonyms
        extract_metadata unless @synonyms
        @synonyms
      end

      def encoding
        extract_metadata unless @encoding
        @encoding
      end

      include Source
    end
  end
end
