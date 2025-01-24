# TODO Make it so we can load this direct;
# at the moment require 'tex/hyphen/texlive' fails
# unless we did require 'tex/hyphen' first (Psych isn’t found)
require_relative 'texlive/source'
require_relative 'texlive/loader'
require_relative 'texlive/package'

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
