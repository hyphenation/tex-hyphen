require 'spec_helper'

describe TeX::Hyphen::Patterns do
  describe '.new' do
    it "sets the path to the pattern files" do
      expect(TeX::Hyphen::Patterns.class_variable_get :@@topdir).to eq File.expand_path('../../../../hyph-utf8/tex/generic/hyph-utf8/patterns', __FILE__)
    end

    it "loads all names of the TeX files" do
      patterns = TeX::Hyphen::Patterns.new
      expect(patterns.instance_variable_get(:@texfiles).count).to eq 79
    end

    it "loads all names of the text pattern files" do
      patterns = TeX::Hyphen::Patterns.new
      expect(patterns.instance_variable_get(:@txtfiles).count).to eq 77
    end
  end
end

describe TeX::Hyphen::Language do
  describe '.new' do
    it "creates a new Language instance"
    it "sets the BCP47 tag"
    it "sets the patterns"
    it "sets the hyphenation exceptions"
  end

  describe '.all' do
    it "sets the @@languages class variable" do
      TeX::Hyphen::Language.all
      expect(TeX::Hyphen::Language.class_variable_get :@@languages).to be_an Hash
    end

    it "lists all languages" do
      expect(TeX::Hyphen::Language.all.count).to eq 77
    end
  end

  describe '.find_by_bcp47' do
    it "finds the language for that BCP47 tag"
  end
end

# Language
#   #bcp47
#     returns the BCP47 tag of the language
#     calls Language.all first
#   #patterns
#     returns the patterns
#     loads the patterns first
#   #hyphenate
#     hyphenates
#     initialises the hydra if needed
#
# Finished in 1.87 seconds (files took 0.52834 seconds to load)
# 11 examples, 0 failures
#
