require 'spec_helper'

include TeX::Hyphen

describe Language do
  describe 'class variables' do
    it "sets the path to the pattern files" do
      expect(Language.class_variable_get :@@topdir).to match /tex\/generic\/hyph-utf8\/patterns$/
    end

    it "has an end-of-header marker" do
      expect(Language.class_variable_get :@@eohmarker).to match /^\={42}$/
    end
  end

  describe '.new' do
    it "creates a new Language instance" do
      expect(Language.new).to be_a Language
    end

    it "takes an optional BCP47 tag as argument" do
      language = Language.new('ro')
      expect(language.instance_variable_get :@bcp47).to eq 'ro'
    end
  end

  describe '.all' do
    it "sets the @@languages class variable" do
      Language.all
      expect(Language.class_variable_get :@@languages).to be_an Hash
    end

    it "lists all languages" do
      expect(Language.all.count).to eq 79
    end
  end

  describe '.find_by_bcp47' do
    it "finds the language for that BCP47 tag" do
      language = Language.find_by_bcp47 'bn'
      expect(language).to be_a Language
    end

    it "calls .all first" do
      expect(Language).to receive(:all).and_return({ 'cy' => Language.new('cy') })
      Language.find_by_bcp47('cy')
    end
  end

  describe '#bcp47' do # TODO Add #8bitenc
    it "returns the BCP47 tag of the language" do
      language = Language.new('oc')
      expect(language.bcp47).to eq 'oc'
    end

    it "calls Language.all first" do
      expect(Language).to receive(:all).and_return({ 'pl' => Language.new('pl') })
      Language.new('pl').bcp47
    end
  end

  describe '#name' do
    let(:new_orthography_german) { Language.new('de-1996') }

    it "returns the name" do 
      expect(new_orthography_german.name).to eq 'German, reformed spelling'
    end

    it "calls #extract_metadata first if necessary" do
      expect(new_orthography_german).to receive(:extract_metadata).and_return({ 'name' => 'German, reformed spelling' })
      new_orthography_german.name
    end

    it "doesn’t call #extract_metadata if @name is already set" do
      new_orthography_german.instance_variable_set :@name, 'Deutch in neuer Rechtschreibung'
      expect(new_orthography_german).not_to receive :extract_metadata
      new_orthography_german.name
    end
  end

  describe '#licences' do
    let(:church_slavonic) { Language.new('cu') }

    it "returns the licences as an array" do
      expect(church_slavonic.licences).to eq ['MIT']
    end

    it "call #extract_metadata first if necessary" do
      expect(church_slavonic).to receive(:extract_metadata)
      church_slavonic.licences
    end

    it "doesn’t call #extract_metadata if @licences is already set" do
      church_slavonic.instance_variable_set :@licences, ['MIT licence']
      expect(church_slavonic).not_to receive :extract_metadata
      church_slavonic.licences
    end
  end

  describe '#lefthyphenmin' do
    let(:swiss_spelling_german) { Language.new('de-ch-1901') }

    it "returns the left hyphenmin value for typesetting" do
      expect(swiss_spelling_german.lefthyphenmin).to eq 2
    end

    it "calls #extract_metadata first if necessary" do
      expect(swiss_spelling_german).to receive :extract_metadata
      swiss_spelling_german.lefthyphenmin
    end

    it "doesn’t call #extract_metadata if @lefthyphenmin is already set" do
      swiss_spelling_german.instance_variable_set :@lefthyphenmin, 1
      expect(swiss_spelling_german).not_to receive :extract_metadata
      swiss_spelling_german.lefthyphenmin
    end
  end

  describe '#righthyphenmin' do
    let(:french) { Language.new('fr') }

    it "returns the right hyphenmin value for typesetting" do
      expect(french.righthyphenmin).to eq nil
    end

    it "call #extract_metadata first if necessary" do
      expect(french).to receive :extract_metadata
      french.righthyphenmin
    end

    it "doesn’t call #extract_metadata if @righthyphenmin is already set" do
      # puts french.righthyphenmin
      french.instance_variable_set :@righthyphenmin, 2
      # puts french.righthyphenmin
      expect(french).not_to receive :extract_metadata
      french.righthyphenmin
    end
  end

  describe '#authors' do
    let(:traditional_orthography_german) { Language.new('de-1901') }

    it "returns the authors as an array" do
      expect(traditional_orthography_german.authors).to eq ['Deutschsprachige Trennmustermannschaft']
    end

    it "calls #extract_metadata first if necessary" do
      expect(traditional_orthography_german).to receive :extract_metadata
      traditional_orthography_german.authors
    end

    it "doesn’t call #extract_metadata if @authors is already set" do
      traditional_orthography_german.instance_variable_set :@authors, ['German hyphenation patterns team']
      expect(traditional_orthography_german).not_to receive :extract_metadata
      traditional_orthography_german.authors
    end
  end

  describe '#patterns' do
    it "returns the patterns" do
      language = Language.new('da')
      expect(language.patterns).to match /^\.ae3\n\.an3k\n\.an1s/
    end

    it "calls .all first" do
      language = Language.new('eu')
      expect(Language).to receive(:all).and_return({ 'eu' => Language.new('eu') })
      language.patterns
    end

    it "loads the patterns" do
      language = Language.new('fi')
      expect(language.patterns).to match /uu1a2\nuu1e2\nuu1o2\nuu1i2/
    end

    it "doesn’t crash on inexistent patterns" do
      expect { Language.new('zu').patterns }.not_to raise_exception
    end

    it "caches the list of patterns" do
      language = Language.new('ru')
      language.patterns
      expect(language.instance_variable_get :@patterns).to match /\.аб1р\n\.аг1ро\n\.ади2/
    end
  end

  describe '#exceptions' do
    it "returns the hyphenation exceptions" do
      language = Language.new('ga')
      expect(language.patterns).to match /^\.ab4ai\n\.ab6ar\n\.ab5r/
    end

    it "calls .all first" do
      language = Language.new('hu')
      expect(Language).to receive(:all).and_return({ 'hu' => Language.new('hu') })
      language.patterns
    end

    it "loads the exceptions" do
      language = Language.new('is')
      expect(File).to receive(:read).and_return("alc-un alc-u-nis-si-me alc-un-men-te")
      language.patterns
    end

    it "doesn’t crash on inexistent patterns" do
      expect { Language.new('iu').exceptions}.not_to raise_exception
    end

    it "caches the exceptions" do
      language = Language.new('sk')
      language.exceptions
      expect(language.instance_variable_get :@exceptions).to match /dosť\nme-tó-da\nme-tó-dy/
    end

    it "hashes the exceptions" do
      language = Language.new('en-gb')
      language.exceptions
      hyphenation = language.instance_variable_get :@hyphenation
      expect(hyphenation.count).to eq 8
      expect(hyphenation['however']).to eq 'how-ever'
    end
  end

  describe '#hyphenate' do
    it "hyphenates with the appropriate patterns" do
      czech = Language.new('cs')
      expect(czech.hyphenate('ubrousek')).to eq 'ubrou-sek'
    end

    it "takes hyphenmins in account if available" do
      language = Language.new('de-1996')
      expect(language.hyphenate('Zwangsvollstreckungsmaßnahme')).to eq 'zwangs-voll-stre-ckungs-maß-nah-me'
    end

    it "takes exceptions in account if available" do
      american_english = Language.new('en-us')
      expect(american_english.hyphenate('project')).to eq 'project'
    end

    it "initialises the hydra if needed" do
      language = Language.new('de-1901')
      language.hyphenate('Zwangsvollstreckungsmaßnahme')
      expect(language.instance_variable_get(:@hydra)).to be_a Hydra
    end

    it "calls #exceptions" do
      esperanto = Language.new('eo')
      expect(esperanto).to receive(:exceptions)
      esperanto.instance_variable_set :@hyphenation, { 'ŝtatregosciencon' => 'ŝta-tre-go-scien-con' }
      esperanto.hyphenate('ŝtatregosciencon')
    end
  end

  describe '#extract_metadata' do
    it "returns a hash with the metadata" do
      language = Language.new('bg')
      expect(language.extract_metadata).to be_a Hash
    end

    it "raises an exception if the metadata is invalid" do
      language = Language.new('sl')
      expect { language.extract_metadata }.to raise_exception InvalidMetadata
    end

    it "raises an exception if the metadata is just a string" do
      language = Language.new('cs')
      expect { language.extract_metadata }.to raise_exception InvalidMetadata
    end
  end

  describe '#parse_tex_file' do
    it "sets the language name" do
      language = Language.new('th')
      language.extract_metadata
      expect(language.instance_variable_get :@name).to eq 'Thai'
    end

    it "sets the licence list" do
      language = Language.new('la')
      language.extract_metadata
      expect(language.instance_variable_get :@licences).to eq ['MIT', 'LPPL']
    end

    it "sets lefthyphenmin" do
      pali = Language.new('pi')
      pali.extract_metadata
      expect(pali.instance_variable_get :@lefthyphenmin).to eq 1
    end

    it "sets righthyphenmin" do
      german = Language.new('de-1996')
      german.extract_metadata
      expect(german.instance_variable_get :@righthyphenmin).to eq 2
    end

    it "sets the 8-bit encoding"

    it "sets the list of authors" do
      liturgical_latin = Language.new('la-x-liturgic')
      liturgical_latin.extract_metadata
      expect(liturgical_latin.instance_variable_get :@authors).to eq ['Claudio Beccari', 'Monastery of Solesmes', 'Élie Roux']
    end

    it "raises an exception if the licence is missing" do
      croatian = Language.new('hr')
      expect { croatian.extract_metadata }.to raise_exception InvalidMetadata
    end
  end
end
