require 'spec_helper'

include TeX::Hyphen

describe Converter do
  describe '.scan_line' do
    it "scans the line" do
      eightbits, usv = Converter.scan_line "0xDF\tU+042F"
      expect(eightbits).to eq 223
      expect(usv).to eq 'Я'
    end

    it "can read an optional name" do
      eightbits, usv, bool, name = Converter.scan_line "0x2E\tU+002E\t\tperiod"
      expect(eightbits).to eq 46
      expect(usv).to eq '.'
      expect(bool).to eq 0
      expect(name).to eq 'period'
    end

    it "doesn’t crash if there is no match" do
      expect { Converter.scan_line "" }.not_to raise_exception
    end

    it "returns nil if there are no matches" do
      b = Converter.scan_line "0x2F"
      expect(b).to be_nil
    end

    it "can also have a useless strange entry" do
      eightbits, usv, bool, name = Converter.scan_line "0x19\tU+0131\t1\tdotlessi"
      expect(eightbits).to eq 25
      expect(usv).to eq 'ı'
      expect(bool).to eq 1
      expect(name).to eq 'dotlessi'
    end
  end
end
