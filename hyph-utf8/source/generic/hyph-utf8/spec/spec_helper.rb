$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'tex/hyphen/language'
require 'tex/hyphen/texlive/package'
require 'tex/hyphen/texlive'
require 'tex/hyphen/texlive/loader'
require 'tex/hyphen/converter'

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
