require 'spec_helper'

describe TeX::Hyphen::Language do
  describe 'class variables' do
    it "sets the path to the pattern files" do
      expect(TeX::Hyphen::Language.class_variable_get :@@topdir).to match /tex\/generic\/hyph-utf8\/patterns$/
    end

    it "has an end-of-header marker" do
      expect(TeX::Hyphen::Language.class_variable_get :@@eohmarker).to match /^\={42}$/
    end
  end

  describe '.new' do
    it "creates a new Language instance" do
      expect(TeX::Hyphen::Language.new).to be_a TeX::Hyphen::Language
    end

    it "takes an optional BCP47 tag as argument" do
      language = TeX::Hyphen::Language.new('ro')
      expect(language.instance_variable_get :@bcp47).to eq 'ro'
    end
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
    it "finds the language for that BCP47 tag" do
      language = TeX::Hyphen::Language.find_by_bcp47 'bn'
      expect(language).to be_a TeX::Hyphen::Language
    end

    it "calls .all first" do
      expect(TeX::Hyphen::Language).to receive(:all).and_return({ 'cy' => TeX::Hyphen::Language.new('cy') })
      TeX::Hyphen::Language.find_by_bcp47('cy')
    end
  end

  describe '#bcp47' do # TODO Add #name, #licences, #lefthyphenmin, #righthyphenmin, #authors, #8bitenc
    it "returns the BCP47 tag of the language" do
      language = TeX::Hyphen::Language.new('oc')
      expect(language.bcp47).to eq 'oc'
    end

    it "calls Language.all first" do
      expect(TeX::Hyphen::Language).to receive(:all).and_return({ 'pl' => TeX::Hyphen::Language.new('pl') })
      TeX::Hyphen::Language.new('pl').bcp47
    end
  end

  describe '#patterns' do
    it "returns the patterns" do
      language = TeX::Hyphen::Language.new('da')
      expect(language.patterns).to match /^\.ae3\n\.an3k\n\.an1s/
    end

    it "calls .all first" do
      language = TeX::Hyphen::Language.new('eu')
      expect(TeX::Hyphen::Language).to receive(:all).and_return({ 'eu' => TeX::Hyphen::Language.new('eu') })
      language.patterns
    end

    it "loads the patterns" do
      language = TeX::Hyphen::Language.new('fi')
      expect(language.patterns).to match /uu1a2\nuu1e2\nuu1o2\nuu1i2/
      # expect(language.patterns).to match /yli-opisto.*xxs-osakas.*suur-ajot/
    end

    it "doesn’t crash on inexistent patterns" do
      expect { TeX::Hyphen::Language.new('zu').patterns }.not_to raise_exception
    end

    it "caches the list of patterns" do
      language = TeX::Hyphen::Language.new('ru')
      language.patterns
      expect(language.instance_variable_get :@patterns).to match /\.аб1р\n\.аг1ро\n\.ади2/
    end
  end

  describe '#exceptions' do
    it "returns the hyphenation exceptions" do
      language = TeX::Hyphen::Language.new('ga')
      expect(language.patterns).to match /^\.ab4ai\n\.ab6ar\n\.ab5r/
    end

    it "calls .all first" do
      language = TeX::Hyphen::Language.new('hu')
      expect(TeX::Hyphen::Language).to receive(:all).and_return({ 'hu' => TeX::Hyphen::Language.new('hu') })
      language.patterns
    end

    it "loads the exceptions" do
      language = TeX::Hyphen::Language.new('is')
      # expect(File).to receive(:read).and_return(".a∂3 .a∂a4 .a∂k2")
      expect(File).to receive(:read).and_return("alc-un alc-u-nis-si-me alc-un-men-te")
      language.patterns
    end

    it "doesn’t crash on inexistent patterns" do
      expect { TeX::Hyphen::Language.new('iu').exceptions}.not_to raise_exception
    end

    it "caches the exceptions" do
      language = TeX::Hyphen::Language.new('sk')
      language.exceptions
      expect(language.instance_variable_get :@exceptions).to match /dosť\nme-tó-da\nme-tó-dy/
    end
  end

  describe '#hyphenate' do
    it "hyphenates with the appropriate patterns and exceptions" do
      language = TeX::Hyphen::Language.new('de-1996')
      expect(language.hyphenate('Zwangsvollstreckungsmaßnahme')).to eq 'zwangs-voll-stre-ckungs-maß-nahme'
      # FIXME expect(language.hyphenate('Zwangsvollstreckungsmaßnahme')).to eq 'zwangs-voll-stre-ckungs-maß-nah-me'
    end

    it "initialises the hydra if needed" do # TODO hyphenmins
      language = TeX::Hyphen::Language.new('de-1901')
      language.hyphenate('Zwangsvollstreckungsmaßnahme')
      expect(language.instance_variable_get(:@hydra)).to be_a Hydra
    end
  end

  describe '#extract_metadata' do
    it "returns a hash with the metadata" do
      language = TeX::Hyphen::Language.new('bg')
      expect(language.extract_metadata).to be_a Hash
    end

    it "raises an exception if the metadata is invalid" do
      language = TeX::Hyphen::Language.new('sl')
      expect { language.extract_metadata }.to raise_exception TeX::Hyphen::InvalidMetadata # FIXME Figure out why it does
    end
  end

  describe '#parse_tex_file' do
    it "sets the language name" do
      language = TeX::Hyphen::Language.new('th')
      language.extract_metadata
      expect(language.instance_variable_get :@name).to eq 'Thai'
    end

    it "sets the licence list" do
      language = TeX::Hyphen::Language.new('la')
      language.extract_metadata
      expect(language.instance_variable_get :@licences).to eq ['MIT', 'LPPL']
    end

    it "sets lefthyphenmin" do
      pali = TeX::Hyphen::Language.new('pi')
      pali.extract_metadata
      expect(pali.instance_variable_get :@lefthyphenmin).to eq 1
    end

    it "sets righthyphenmin" do
      german = TeX::Hyphen::Language.new('de-1996')
      german.extract_metadata
      expect(german.instance_variable_get :@righthyphenmin).to eq 2
    end

    it "sets the 8-bit encoding"

    it "sets the list of authors" do
      liturgical_latin = TeX::Hyphen::Language.new('la-x-liturgic')
      liturgical_latin.extract_metadata
      expect(liturgical_latin.instance_variable_get :@authors).to eq ['Claudio Beccari', 'Monastery of Solesmes', 'Élie Roux']
    end

    it "raises an exception if the licence is missing" do
      croatian = TeX::Hyphen::Language.new('hr')
      expect { croatian.extract_metadata }.to raise_exception TeX::Hyphen::InvalidMetadata
    end
  end
end
