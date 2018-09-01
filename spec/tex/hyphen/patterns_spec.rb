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
