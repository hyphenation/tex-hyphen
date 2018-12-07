require_relative 'texlive/source'
require_relative 'texlive/loader'

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
      include Loader
    end
  end
end
