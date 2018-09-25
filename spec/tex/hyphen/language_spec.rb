require 'spec_helper'

include TeX::Hyphen

describe String do
  describe '#superstrip' do
    it "calls String#strip" do
      str = " foo bar "
      expect(str).to receive(:strip).and_return "foo bar"
      str.superstrip
    end

    it "strips TeX comments" do
      expect("foo % bar".superstrip).to eq "foo "
    end
  end

  describe '#supersplit' do
    it "calls String#strip" do
      str = "foo  bar "
      expect(str).to receive(:strip).and_return "foo  bar"
      str.supersplit
    end

    it "splits across whitespace ranges" do
      expect("foo  bar".supersplit).to eq ["foo", "bar"]
    end
  end

  describe '#safe' do
    it "strips hyphens" do
      expect("foo-bar".safe).to eq "foobar"
    end

    it "strips spaces" do
      expect("ancient greek".safe).to eq "ancientgreek"
    end
  end

  describe '#titlecase' do
    it "capitalises each word" do
      expect("modern greek".titlecase).to eq "Modern Greek"
    end
  end
end

# TODO?  Spec out PATH module

describe Author do
  describe 'Class methods' do
    describe '.authors' do
      it "returns a hash of authors" do
        expect(Author.authors).to be_a Hash
      end
    end

    describe '.all' do
      it "returns the array of authors" do
        expect(Author.all).to be_an Array
      end
    end

    describe '.[]' do
      it "returns the author for the key" do
        expect(Author['donald_knuth']).to be_an Author
      end
    end
  end

  describe 'Instance methods' do
    let(:dek) { Author['donald_knuth'] }

    describe '#name' do
      it "returns the author’s name" do
        expect(dek.name).to eq 'Donald'
      end
    end

    describe '#surname' do
      it "returns the author’s surname" do
        expect(dek.surname).to eq 'Knuth'
      end
    end

    describe '#email' do
      it "returns the email" do
        expect(dek.email).to be_nil
      end
    end
  end
end

describe Language do
  describe 'Class variables' do
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
      # All the TeX files.  Note [no] and [mn-cyrl-x-lmc] don’t have corresponding plain text files.
      expect(Language.all.count).to eq 82 # Was 79; 3 more “TeX Live dummies” [ar] [fa] [grc-x-ibycus] TODO Maybe remove
    end
  end

  describe '.all_with_licence' do
    it "returns all languages that have a non-empty licence" do
      expect(Language.all_with_licence.count).to eq 75 # 79 - [ro, cop, mn-cyrl-x-lmc, ?]
    end

    it "calls .all first" do
      expect(Language).to receive(:all).and_return({ 'pl' => Language.new('pl') })
      Language.all_with_licence
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

  describe '#displayname' do
    it "returns @name most of the name" do
      romansh = Language.new('rm')
      expect(romansh.displayname).to eq 'Romansh'
    end

    it "strips to the language subtag part" do
      polytonic_greek = Language.new('el-polyton')
      expect(polytonic_greek.displayname).to eq 'Greek'
    end

    it "returns Norwegian for [nb] and [no]" do
      bokmål = Language.new('nb')
      pending "Need to add authors everywhere"
      expect(bokmål.displayname).to eq 'Norwegian'
    end

    it "returns Serbian for [sh]" do
      serbocroatian_cyrillic = Language.new('sh-cyrl')
      expect(serbocroatian_cyrillic.displayname).to eq 'Serbian'
    end

    it "calls #extract_metadata if needed" do
      friulan = Language.new('fur')
      expect(friulan).to receive :extract_metadata
      friulan.displayname
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

    it "raises an exception if @licences is nil or empty" do
      nolicence = Language.new('qnl')
      allow(File).to receive(:read).and_return("code: qnl\nauthors:\n  - me")
      expect { nolicence.licences }.to raise_exception NoLicence
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
      french.instance_variable_set :@righthyphenmin, 2
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
      expect(traditional_orthography_german).to receive(:extract_metadata).and_return({ authors: ['Werner Lemberg', 'others'] })
      traditional_orthography_german.authors
    end

    it "doesn’t call #extract_metadata if @authors is already set" do
      traditional_orthography_german.instance_variable_set :@authors, ['German hyphenation patterns team']
      expect(traditional_orthography_german).not_to receive :extract_metadata
      traditional_orthography_german.authors
    end
  end

  describe '#github_link' do
    it "returns the GitHub link" do
      upper_sorbian = Language.new('hsb')
      expect(upper_sorbian.github_link).to eq 'https://github.com/hyphenation/tex-hyphen/tree/master/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-hsb.tex'
    end
  end

  describe '#<=>' do
    it "compares Language’s using @name’s" do
      expect(Language.new('de-1996') <=> Language.new('fr')).to eq 1
    end

    it "uses BCP47 codes if names are not available" do
      expect(Language.new('zh-latn-pinyin') <=> Language.new('cu')).to eq 1
    end
  end

  describe '#readtexfile' do
    let(:basque) { Language.new('eu') }

    it "reads the TeX file" do
      expect(File).to receive(:read)
      basque.readtexfile
    end

    it "stores the contents into the @@texfile class variable" do
      basque.readtexfile
      expect(Language.class_variable_get(:@@texfile)['eu']).to match /1ba.*1ko.*1t2xe.*su2b2r/m
    end

    it "recovers gracefully from nonexistent files" do
      expect { Language.new('kl').readtexfile }.not_to raise_exception
    end
  end

  describe '#patterns' do
    it "returns the patterns" do
      danish = Language.new('da')
      expect(['.ae3', '.an3k', '.an1s'].all? { |p| danish.patterns.include? p }).to be_truthy
    end

    it "calls .all first" do
      language = Language.new('eu')
      expect(Language).to receive(:all).and_return({ 'eu' => Language.new('eu') })
      pending "Needs pondering"
      language.patterns
    end

    it "loads the patterns" do
      language = Language.new('fi')
      # byebug
      expect(language.patterns[151..154]).to eq ['uu1a2', 'uu1e2', 'uu1o2', 'uu1i2']
    end

    it "doesn’t crash on inexistent patterns" do
      expect { Language.new('zu').patterns }.not_to raise_exception
    end

    it "caches the list of patterns" do
      language = Language.new('ru')
      language.patterns
      expect(language.instance_variable_get(:@patterns)[0..2]).to eq ['.аб1р', '.аг1ро', '.ади2']
    end

    it "uses the [no] patterns for [nb]" do
      expect(Language.new('nb').patterns).to eq Language.new('no').patterns
    end

    it "expands the Esperanto patterns" do
      esperanto = Language.new('eo')
      expect(['.di3s2a.', '.di3s2aj.', '.di3s2ajn.', '.di3s2an.', '.di3s2e.'].any? { |p| esperanto.patterns.include? p }).to be_truthy
    end
  end

  describe '#exceptions' do
    it "returns the hyphenation exceptions" do
      language = Language.new('ga')
      # byebug
      expect(language.exceptions[0..2]).to eq ['bhrachtaí', 'mbrachtaí', 'cháintí']
    end

    it "calls .all first" do
      language = Language.new('hu')
      pending "Needs examining"
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
      expect(language.instance_variable_get(:@exceptions)[0..2]).to match ['dosť', 'me-tó-da', 'me-tó-dy']
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

    it "raises an exception if the metadata is just a string" do
      language = Language.new('qls')
      allow(File).to receive(:read).and_return("just a string")
      expect { language.extract_metadata }.to raise_exception InvalidMetadata
    end

    it "raises an exception if the licence is missing" do
      language = Language.new('qlv')
      allow(File).to receive(:read).and_return("name: language virtual\ncode: qlv")
      expect { language.extract_metadata }.to raise_exception InvalidMetadata
    end

    it "raises an exception if @authors is nil or empty" do
      not_church_slavonic = Language.new('qcu')
      allow(File).to receive(:read).and_return "code: qcu\nlicence:\n  name:\n    MIT"
      # pending "After the big merge, real files need fixing"
      expect { not_church_slavonic.authors }.to raise_exception NoAuthor
    end

    it "doesn’t crash on invalid licence entries" do
      syntax_error = Language.new('qse')
      allow(File).to receive(:read).and_return "foo:\nbar"
      expect { syntax_error.extract_metadata }.not_to raise_exception Psych::SyntaxError
    end

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

    pending "sets the 8-bit encoding" do
      Language.new('sl').tex8bit
    end

    it "sets the list of authors" do
      liturgical_latin = Language.new('la-x-liturgic')
      liturgical_latin.extract_metadata
      expect(liturgical_latin.instance_variable_get :@authors).to eq ['Claudio Beccari', 'Monastery of Solesmes', 'Élie Roux']
    end
  end

  describe Package do
    let(:latin) { Package.find('latin') }
    let(:german) { Package.find('german') }
    let(:hungarian) { Package.find('hungarian') }
    let(:norwegian) { Package.find('norwegian') }

    describe "Instance variables" do
      it "has a @name" do
        expect(latin.name).to eq 'latin'
      end
    end

    describe "#description_s" do
      it "returns the short description" do
        expect(latin.description_s).to eq 'Latin hyphenation patterns'
      end
    end

    describe "#description_l" do
      it "returns the long description" do
        expect(latin.description_l.join).to match /^Hyphenation patterns for.*modern spelling.*medieval spelling.*Classical Latin.*Liturgical Latin/
      end
    end

    describe "#languages" do
      it "returns the list of languages" do
        expect(latin.languages.map(&:code)).to eq ['la', 'la-x-classic', 'la-x-liturgic']
      end
    end

    describe "#has_dependency?" do
      it "returns the external dependencies" do
        expect(german.has_dependency?).to eq "dehyph"
      end
    end

    describe "#list_dependencies" do
      it "lists the dependencies" do
        # FIXME Should return ['depend hyphen-base', 'depend hyph-utf8', 'depend dehyph'] or nothing
        expect(german.has_dependency?).to eq 'dehyph'
      end
    end

    describe "#list_support_files" do # FIXME? list_non_run_files
      it "lists doc and source files" do
        expect(hungarian.list_support_files('doc')).to eq ['doc/generic/hyph-utf8/languages/hu', 'doc/generic/huhyphen']
        # FIXME Should return ['texmf-dist/doc/generic/huhyphen', 'texmf-dist/doc/generic/hyph-utf8/languages/hu'] or nothing
      end
    end

    describe "#list_run_files" do
      it "lists the run-time files" do
        norwegian_run = norwegian.list_run_files
        expect(norwegian_run.count).to eq 15
        expect(norwegian_run.select { |f| f =~ /tex\/hyph-[^\.]*\.tex$/ }).to eq ['tex/generic/hyph-utf8/patterns/tex/hyph-no.tex',
          'tex/generic/hyph-utf8/patterns/tex/hyph-nb.tex',
          'tex/generic/hyph-utf8/patterns/tex/hyph-nn.tex']
      end
    end

    describe '#<=>' do
      it "compares two Package’s" do
        expect(hungarian <=> german).to eq 1
      end
    end

    describe '#find' do
      it "returns the package with that name" do
        expect(Package.find('norwegian')).to eq norwegian
      end
    end
  end
end
