
class Language
	def initialize(language_hash)
		@use_new_loader = language_hash["use_new_loader"]
		@use_old_patterns = language_hash["use_old_patterns"]
		@filename_old_patterns = language_hash["filename_old_patterns"]
		@filename_xu_loader = language_hash["filename_xu_loader"]
		@code = language_hash["code"]
		@name = language_hash["name"]
		@synonyms = language_hash["synonyms"]
		@hyphenmin = language_hash["hyphenmin"]
		@encoding = language_hash["encoding"]
		@exceptions = language_hash["exceptions"]
		@message = language_hash["message"]
	end
	
	attr_reader :use_new_loader, :use_old_patterns, :filename_old_patterns, :filename_xu_loader, :code, :name, :synonyms, :hyphenmin, :encoding, :exceptions, :message
end

# "use_new_loader"
# => true - create a new file and use that one
# => false - use "filename_old_patterns" in language.dat
# "filename_old_patterns"
# => [string] - the name used in language.dat if "use_new_loader" is false
# "eightbitfilename"
# => [string] - if set, load another file for 8-bit engines
# "code"
# => [string] - used in filenames, needs to conform to the standard
# "name"
# => [string] -
# "synonyms" => [],
# "hyphenmin" => [],
# "encoding" => nil,
# "exceptions" => false,
# "message" => nil,



class Languages
	@@list = []
	
	def initialize
		languages = [
# arabic		zerohyph.tex
{
	"use_new_loader" => false,
	"use_old_patterns" => false,
	"filename_old_patterns" => "zerohyph.tex",
	"filename_xu_loader" => nil,
	"code" => "ar",
	"name" => "arabic",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,
},
# basque		xu-bahyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "bahyph.tex",
	"filename_xu_loader" => "xu-bahyph.tex",
	"code" => "eu",
	"name" => "basque",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ascii",
	"exceptions" => false,
	"message" => nil,
},
# coptic		xu-copthyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "copthyph.tex",
	"filename_xu_loader" => "xu-copthyph.tex",
	"code" => "cop",
	"name" => "coptic",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,
},
# welsh		cyhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "cyhyph.tex",
	"filename_xu_loader" => nil,
	"code" => "cy",
	"name" => "welsh",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ascii",
	"exceptions" => false,
	"message" => nil,
},
# czech		xu-czhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "czhyph.tex",
	"filename_xu_loader" => "xu-czhyph.tex",
	"code" => "cs",
	"name" => "czech",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Loading CZ hyphenation patterns: Pavel Sevecek, v3, 1995",
},
# slovak		xu-skhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "skhyph.tex",
	"filename_xu_loader" => "xu-skhyph.tex",
	"code" => "sk",
	"name" => "slovak",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Loading SK hyphenation patterns: Jana Chlebikova, 1992",
},
# german		xu-dehypht.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "dehypht.tex",
	"filename_xu_loader" => "xu-dehypht.tex",
	"code" => "de-1901",
	"name" => "german",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Traditional German Hyphenation Patterns", # was: `dehypht-x' 2008/06/01 (WL) for utf-8
},
# ngerman		xu-dehyphn.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "dehyphn.tex",
	"filename_xu_loader" => "xu-dehyphn.tex",
	"code" => "de-1996",
	"name" => "ngerman",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Reformed German Hyphenation Patterns",
},
# danish		dkhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "dkhyph.tex",
	"filename_xu_loader" => nil,
	"code" => "da",
	"name" => "danish",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => nil,
},
# esperanto	xu-eohyph.tex
# TODO
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "eohyph.tex",
	"filename_xu_loader" => "xu-eohyph.tex",
	"code" => "eo",
	"name" => "esperanto",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "il3", # TODO
	"exceptions" => false,
	"message" => "Esperanto Hyphenation Patterns, 1999-08-10",
},
# spanish		xu-eshyph.tex
# =espanol
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "eshyph.tex",
	"filename_xu_loader" => "xu-eshyph.tex",
	"code" => "es",
	"name" => "spanish",
	"synonyms" => ["espanol"],
	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => nil,
},
# catalan		cahyph.tex
{
	"filename_old_patterns" => "cahyph.tex",
	"filename_xu_loader" => "xu-cahyph.tex",
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "ca",
	"name" => "catalan",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Catalan Hyphenation Patterns",
},
# galician	xu-glhyph.tex
{
	"filename_old_patterns" => "glhyph.tex",
	"filename_xu_loader" => "xu-glhyph.tex",
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "gl",
	"name" => "galician",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Galician Hyphenation Patterns",
},
# estonian	xu-ethyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "ethyph.tex",
	"filename_xu_loader" => "xu-ethyph.tex",
	"code" => "et",
	"name" => "estonian",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Estonian Hyphenation Patterns",
},
# farsi		zerohyph.tex
# =persian
{
	"use_new_loader" => false,
	"use_old_patterns" => false,
	"filename_old_patterns" => "zerohyph.tex",
	"filename_xu_loader" => nil,
	"code" => "fa",
	"name" => "farsi",
	"synonyms" => ["persian"],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,
},
# finnish		fihyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "fihyph.tex",
	"filename_xu_loader" => nil,
	"code" => "fi",
	"name" => "finnish",
	"synonyms" => [],
	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => nil,
},
# french		xu-frhyph.tex
# =patois
# =francais
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "frhyph.tex",
	"filename_xu_loader" => "xu-frhyph.tex",
	"code" => "fr",
	"name" => "french",
	"synonyms" => ["patois","francais"],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "French hyphenation patterns V2.12, 2002/12/11",
},
# croatian	xu-hrhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "hrhyph.tex",
	"filename_xu_loader" => "xu-hrhyph.tex",
	"code" => "hr",
	"name" => "croatian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Croatian Hyphenation Patterns",
},
# hungarian	xu-huhyphn.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "huhyphn.tex",
	"filename_xu_loader" => "xu-huhyphn.tex",
	"code" => "hu",
	"name" => "hungarian",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Hungarian Hyphenation Patterns v20031107",
},
# interlingua	iahyphen.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "iahyphen.tex",
	"filename_xu_loader" => nil,
	"code" => "ia",
	"name" => "interlingua",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ascii",
	"exceptions" => true,
	"message" => "Hyphenation Patterns for Interlingua",
},
# indonesian	inhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "inhyph.tex",
	"filename_xu_loader" => nil,
	"code" => "id",
	"name" => "indonesian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ascii",
	"exceptions" => true,
	"message" => "Indonesian Hyphenation Patterns",
},
# icelandic	icehyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "icehyph.tex",
	"filename_xu_loader" => nil,
	"code" => "is",
	"name" => "icelandic",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Icelandic Hyphenation Patterns",
},
# italian		ithyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "ithyph.tex",
	"filename_xu_loader" => nil,
	"code" => "it",
	"name" => "italian",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ascii",
	"exceptions" => false,
	"message" => nil,
},
# latin		xu-lahyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "lahyph.tex",
	"filename_xu_loader" => "xu-lahyph.tex",
	"code" => "la",
	"name" => "latin",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => nil,
},
# dutch		nehyph96.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "nehyph96.tex",
	"filename_xu_loader" => nil,
	"code" => "nl",
	"name" => "dutch",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Dutch Hyphenation Patterns",
},
# norsk		xu-nohyphbx.tex
# =norwegian
# nynorsk         nnhyph.tex
# bokmal          nbhyph.tex
# polish		xu-plhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "plhyph.tex",
	"filename_xu_loader" => "xu-plhyph.tex",
	"code" => "pl",
	"name" => "polish",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "qx",
	"exceptions" => true,
	"message" => "Polish Hyphenation Patterns",
},
# portuguese	pthyph.tex
# =portuges
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "pthyph.tex",
	"filename_xu_loader" => nil,
	"code" => "pt",
	"name" => "portuguese",
	"synonyms" => ["portuges"],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Portuguese Hyphenation Patterns",
},
# pinyin		xu-pyhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "pyhyph.tex",
	"filename_xu_loader" => "xu-pyhyph.tex",
	"code" => "zh-latn",
	"name" => "pinyin",
	"synonyms" => [],
	"hyphenmin" => [1,1],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Hyphenation patterns for unaccented pinyin syllables (CJK 4.8.0)",
},
# romanian	xu-rohyphen.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "rohyphen.tex",
	"filename_xu_loader" => "xu-rohyphen.tex",
	"code" => "ro",
	"name" => "romanian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Romanian Hyphenation Patterns", # : `rohyphen' 1.1 <29.10.1996>
},
# slovenian	xu-sihyph.tex
# =slovene
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "sihyph.tex",
	"filename_xu_loader" => "xu-sihyph.tex",
	"code" => "sl",
	"name" => "slovenian",
	"synonyms" => ["slovene"],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Slovenian Hyphenation Patterns",
},
# uppersorbian	xu-sorhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "sorhyph.tex",
	"filename_xu_loader" => "xu-sorhyph.tex",
	"code" => "hsb",
	"name" => "uppersorbian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Hyphenation patterns for Upper Sorbian, E. Werner",
#	\message{Hyphenation patterns for Upper Sorbian, E. Werner}
#	\message{Completely new revision 1997, March 22}
},
# swedish		svhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "svhyph.tex",
	"filename_xu_loader" => nil,
	"code" => "sv",
	"name" => "swedish",
	"synonyms" => [],
	"hyphenmin" => [1,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Swedish hyphenation patterns, Jan Michael Rynning, 1994-03-03",
},
# turkish		xu-tkhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "tkhyph.tex",
	"filename_xu_loader" => "xu-tkhyph.tex",
	"code" => "tr",
	"name" => "turkish",
	"synonyms" => [],
	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => nil,
},
# ukenglish	ukhyphen.tex
# TODO - should we rename it or not?
{
	"use_new_loader" => false,
	"use_old_patterns" => true,
	"filename_old_patterns" => "ukhyphen.tex",
	"filename_xu_loader" => nil,
	"code" => "en-gb",
	"name" => "ukenglish",
	"synonyms" => [],
	"hyphenmin" => [],
	"encoding" => "ascii",
	"exceptions" => true,
	"message" => nil,
},
# serbian		xu-srhyphc.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "shhyphl.tex",
	"filename_xu_loader" => nil,
	"code" => "sr-latn",
	"name" => "serbian",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Serbian hyphenation patterns in Latin script",
},
# serbianc
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "srhyphc.tex",
	"filename_xu_loader" => nil, # "xu-srhyphc.tex"
	"code" => "sr-cyrl",
	"name" => "serbianc",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "t2a",
	"exceptions" => true,
	"message" => "Serbian hyphenation patterns in Cyrillic script",
},
# mongolian	xu-mnhyph.tex
# TODO
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "mnhyph.tex",
	"filename_xu_loader" => "xu-mnhyph.tex",
	"code" => "mn-cyrl",
	"name" => "mongolian",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Mongolian hyphenation patterns",
},
# mongolian2a
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "mnhyphn.tex",
	"filename_xu_loader" => nil,
	"code" => "mn-cyrl-x-new",
	"name" => "mongolian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "New Mongolian Hyphenation Patterns",
},
# greek		xu-grphyph4.tex
# =polygreek
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "grphyph5.tex",
	"filename_xu_loader" => "xu-grphyph4.tex", # TODO: beware!
	"code" => "el-polyton",
	"name" => "greek",
	"synonyms" => ["polygreek"],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => true,
#	"message" => "Polytonic Greek Hyphenation Patterns",
	"message" => "Hyphenation patterns for multi-accent (polytonic) Modern Greek"
},
# monogreek	xu-grmhyph4.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "grmhyph5",
	"filename_xu_loader" => "xu-grmhyph4.tex", # TODO: beware!
	"code" => "el-monoton",
	"name" => "monogreek",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => true,
#	"message" => "Monotonic Greek Hyphenation Patterns",
	"message" => "Hyphenation patterns for uni-accent (monotonic) Modern Greek"
},
# ancientgreek	xu-grahyph4.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => true,
	"filename_old_patterns" => "grmhyph5",
	"filename_xu_loader" => "xu-grahyph4.tex", # TODO: beware!
	"code" => "grc",
	"name" => "ancientgreek",
	"synonyms" => [],
#	"hyphenmin" => [],
	"encoding" => nil,
	"exceptions" => false,
	"message" => "Hyphenation patterns for Ancient Greek"
},
# ibycus ibyhyph.tex
{
	"use_new_loader" => false,
	"use_old_patterns" => true,
	"filename_old_patterns" => "ibyhyph.tex",
	"filename_xu_loader" => nil,
	"code" => nil,
	"name" => "ibycus",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,
},
# bulgarian	xu-bghyphen.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"filename_old_patterns" => "bghyphen.tex",
	"filename_xu_loader" => "xu-bghyphen.tex",
	"code" => "bg",
	"name" => "bulgarian",
	"synonyms" => [],
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Bulgarian Hyphenation Patterns",
},
# russian	xu-ruhyphen.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "ru",
	"name" => "russian",
	"synonyms" => [],
	# "hyphenmin" => [], # TODO
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Russian Hyphenation Patterns",
},
# ukrainian	xu-ukrhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "uk",
	"name" => "ukrainian",
	"synonyms" => [],
	# "hyphenmin" => [], # ?
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Ukrainian Hyphenation Patterns",
},
# norsk	xu-nohyphbx.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "nb",
	"name" => "norsk",
	"synonyms" => ["norwegian", "bokmal"],
	# "hyphenmin" => [], # ?
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Norwegian Bokmal Hyphenation Patterns",
},
# nynorsk	nnhyph.tex
{
	"use_new_loader" => true,
	"use_old_patterns" => false,
	"code" => "nn",
	"name" => "nynorsk",
	"synonyms" => [],
	# "hyphenmin" => [], # ?
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Norwegian Nynorsk Hyphenation Patterns",
}
		]

		languages.each do |language|
			@@list.push(Language.new(language))
		end
	end
	
	def list
		return @@list
	end
end
