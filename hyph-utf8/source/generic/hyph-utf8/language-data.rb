class OldLanguage
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

	@@language_data = [
{
	"code" => "el-monoton",
	"type"          => "rules",
},
{
	"code" => "el-polyton",
	"type"          => "rules",
},
{
	"code" => "grc",
	"type"          => "rules",
},
{
	"code" => "cop",
	"type"          => "rules",
},
{
	"code" => "de-1901",
        "type"          => "dictionary",
},
{
	"code" => "de-1996",
	"type"          => "dictionary",
},
{
	"code" => "de-ch-1901",
        "type"          => "dictionary",
},
{
	"code" => "ru",
        "type"          => "dictionary",
},
{
	"code" => "uk",
	# "type"          => "rules", # TODO: it is not really clear
},
{
	"code" => "af",
        "type"          => "dictionary",
},
{
	"code" => "ca",
        "type"          => "rules", # not only rules, also patgen, but it is a good approximation
},
{
	"code" => "cs",
	"filename_old_patterns_other" => ["czhyphen.tex","czhyphen.ex"],
	"type"          => "dictionary",
	# Both Czech and Slovak: \lefthyphenmin=2, \righthyphenmin=3
	# Typographical rules allow \righthyphenmin=2 when typesetting in a
	# narrow column (newspapers etc.).
	# (used to be 2,2)

	# guessing based on CTAN/macros/cstex/base/csplain.tar.gz:
	# 1998-12-17 (patterns)
	# 1995-08-23 (exceptions)
	# but patterns claim 1995
},
{
	"code" => "sk",
	"type"          => "dictionary",
	"filename_old_patterns_other" => ["skhyphen.tex","skhyphen.ex"],
},
{
	"code" => "cy",
        "type"          => "dictionary",
},
{
	"code" => "da",
	"type"          => "dictionary",
        "filename_old_patterns_other" => ["dkcommon.tex", "dkspecial.tex"],
},
{
	"code" => "eo",
        "type"          => "rules",
},
{
	"code" => "es",
        "type"          => "dictionary",
},
{
	"code" => "eu",
        "type"          => "rules",
},
{
	"code" => "fr",
        "type"          => "rules",
},
# galician
{
	"code" => "gl",
	"type"          => "rules",
},
# estonian
{
	"code" => "et",
        "type"          => "dictionary",
},
# finnish
{
	"code" => "fi",
	"name" => "finnish",
	"filename_old_patterns" => "fihyph.tex",
	"message" => "Finnish hyphenation patterns",

	"version"       => "2.2",
	"last_modified" => "1989-03-08",
	"type"          => "rules",
	"authors"       => ["kauko_saarinen", "fred_karlsson"],
	"licence"       => "other-free",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Finnish in T1/EC and UTF-8 encodings.",
	],
},
# croatian
{
	"code" => "hr",
	"name" => "croatian",
	"filename_old_patterns" => "hrhyph.tex",
	"message" => "Croatian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "1996-03-19",
	"type"          => "dictionary",
	"authors"       => [ "igor_marinovic" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Croatian in T1/EC and UTF-8 encodings.",
	],
},
# hungarian
{
	"code" => "hu",
	"name" => "hungarian",
	"filename_old_patterns" => "huhyphn.tex",
	"message" => "Hungarian hyphenation patterns",

	"source" => "https://github.com/nagybence/huhyphn/", # FIXME Check and remove from desc below
	"version"       => "v20110815",
	"last_modified" => "2011-08-15", # actually, it is "2009-06-12" or older for contents; we probably want to check/fix this
	"type"          => "dictionary",
	"authors"       => ["bence_nagy"],
	"licence"       => "MPL 1.1/GPL 2.0/LGPL 2.1", # TODO
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Hungarian in T1/EC and UTF-8 encodings.",
		# TODO: same comment as for Irish: I'm slightly reluctant to put URL addresses here.
		"From https://github.com/nagybence/huhyphn/."
	],
},
# armenian
# Sahak Petrosyan <sahak at mit dot edu>
{
	"code" => "hy",
	"name" => "armenian",
	"filename_old_patterns" => nil,
	"message" => "Armenian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2010-05",
	"type"          => "rules",
	"authors"       => ["sahak_petrosyan"],
	"licence"       => "LGPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Armenian for Unicode engines.",
		# "Auto-generated from a script included in hyph-utf8.",
	],
},
# interlingua
{
	"code" => "ia",
	"name" => "interlingua",
	"filename_old_patterns" => "iahyphen.tex",
	"message" => "Hyphenation patterns for Interlingua",

	"version"       => "0.2c",
	"last_modified" => "2005-06-28",
	"type"          => "dictionary",
	"authors"       => ["peter_kleiweg"],
	"licence"       => "LPPL", # TODO Status maintained
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Interlingua in ASCII encoding.",
	],
},
# indonesian
{
	"code" => "id",
	"name" => "indonesian",
	"filename_old_patterns" => "inhyph.tex",
	"message" => "Indonesian hyphenation patterns",

	"version"       => "1.3",
	"last_modified" => "1997-09-19",
	"type"          => "rules",
	"authors"       => ["joerg_knappen", "terry_mart"],
	"licence"       => "GPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Indonesian (Bahasa Indonesia) in ASCII",
		"encoding.  They are probably also usable for Malay (Bahasa Melayu).",
	],
},
# icelandic
{
	"code" => "is",
	"name" => "icelandic",
	"filename_old_patterns" => "icehyph.tex",
	"message" => "Icelandic hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2004-03-02",
	"type"          => "dictionary",
	# TODO: I'm not sure that the last two names are relevant, I don't find the source of Marteinn Sverrisson
	"authors"       => ["jorgen_pind", "marteinn_sverrisson", "kristinn_gylfason"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Icelandic in T1/EC and UTF-8 encodings.",
	],
},
# irish
{
	"code" => "ga",
	"name" => "irish",
	"filename_old_patterns" => "gahyph.tex",
	"message" => "Irish hyphenation patterns",

	"version"       => "1.0",
	"last_modified" => "2004-01-22",
	"type"          => "dictionary",
	"authors"       => ["kevin_p_scannell"],
	"licence"       => "GPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Irish (Gaeilge) in T1/EC and UTF-8 encodings.",
		"Visit http://borel.slu.edu/fleiscin/index.html for more information.",
		# TODO: I'm slightly reluctant to put URL here
	],
},
# italian
{
	"code" => "it",
	"name" => "italian",
	"filename_old_patterns" => "ithyph.tex",
	"message" => "Italian hyphenation patterns",

	"version"       => "4.9",
	"last_modified" => "2014-04-22",
	"type"          => "rules", # TODO: we might want to check that, but it seems unlikely that patgen was used
	"authors"       => ["claudio_beccari"],
	"licence"       => "LPPL", # Status: maintained!
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Italian in ASCII encoding.",
		# supposed to be ...
		"Compliant with the Recommendation UNI 6461 on hyphenation",
		"issued by the Italian Standards Institution",
		"(Ente Nazionale di Unificazione UNI).",
		# "Implements Recommendation UNI 6461 issued by the Italian Standards Institution",
		# "(Ente Nazionale di Unificazione UNI).",
	],
},
# romansh
{
	"code" => "rm",
	"name" => "romansh",
	"filename_old_patterns" => nil,
	"message" => "Romansh hyphenation patterns",

	"version"       => "1.1",
	"last_modified" => "2012-04-10",
	"type"          => "rules",
	"authors"       => ["claudio_beccari"],
	"licence"       => "LPPL", # Status: maintained!
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Romansh in ASCII encoding.",
		"They are supposed to comply with the rules indicated by the Lia",
		"Rumantscha (Romansh language society).",
	],
},
# friulan
{
	"code" => "fur",
	"name" => "friulan", "synonyms" => [],
	"filename_old_patterns" => nil,
	"message" => "Friulan hyphenation patterns",

	"version"       => "1.1",
	"last_modified" => "2012-04-10",
	"type"          => "rules",
	"authors"       => ["claudio_beccari"],
	"licence"       => "LPPL", # Status: maintained!
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Friulan in ASCII encoding.",
		"They are supposed to comply with the common spelling of the",
		"Friulan (Furlan) language as fixed by the Regional Law N.15/96",
		"dated November 6, 1996 and its following amendments.",
	],
},
# piedmontese
{
	"code" => "pms",
	"name" => "piedmontese",
	"filename_old_patterns" => nil,
	"message" => "Piedmontese hyphenation patterns",

	"version"       => "1.0",
	"last_modified" => "2013-02-14",
	"type"          => "rules",
	"authors"       => ["claudio_beccari"],
	"licence"       => "LPPL", # Status: maintained!
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Piedmontese in ASCII encoding.",
		"Compliant with 'Gramatica dla lengua piemonteisa' by Camillo Brero.",
	],
},
# kurmanji
{
	"code" => "kmr",
	"name" => "kurmanji",
	"filename_old_patterns" => "kmrhyph.tex",
	"message" => "Kurmanji hyphenation patterns",

	"version"       => "1.0",
	"last_modified" => "2009-06-29",
	"type"          => "dictionary",
	"authors"       => ["joerg_knappen", "medeni_shemde"],
	"licence"       => "LPPL", # Status: maintained!
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Kurmanji (Northern Kurdish) as spoken in",
		"Turkey and by the Kurdish diaspora in Europe, in T1/EC and UTF-8",
		"encodings."
	],
},
# latin
{
	"code" => "la",
	"name" => "latin",
	"filename_old_patterns" => "lahyph.tex",
	"message" => "Latin hyphenation patterns",

	"version"       => "3.2a",
	"last_modified" => "2014-06-04", # patterns (behaviour) last modified on 2010-06-01
	"type"          => "rules",
	"authors"       => [ "claudio_beccari" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Latin in T1/EC and UTF-8 encodings,",
		"mainly in modern spelling (u when u is needed and v when v is needed),",
		"medieval spelling with the ligatures \\ae and \\oe and the (uncial)",
		"lowercase 'v' written as a 'u' is also supported.  Apparently",
		"there is no conflict between the patterns of modern Latin and",
		"those of medieval Latin.",
	],
},
# classiclatin
{
	"code" => "la-x-classic",
	"name" => "classiclatin",
	"filename_old_patterns" => nil,
	"message" => "Classical Latin hyphenation patterns",

	"version"       => "1.2",
	"last_modified" => "2014-10-06",
	"type"          => "rules",
	"authors"       => [ "claudio_beccari" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for the Classical Latin in T1/EC and UTF-8",
		"encodings. Classical Latin hyphenation patterns are different from",
		"those of 'plain' Latin, the latter being more adapted to modern Latin.",
	],
},
# liturgicallatin
{
	"code" => "la-x-liturgic",
	"name" => "liturgicallatin",
	"filename_old_patterns" => nil,
	"message" => "Liturgical Latin hyphenation patterns",

	"version"       => "1.040",
	"last_modified" => "2016-05-19",
	"type"          => "rules",
	"authors"       => [ "claudio_beccari" ],
	"licence"       => "MIT",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for the Liturgical Latin in T1/EC and UTF-8",
		"encodings.",
	],
},
# lithuanian
{
	"code" => "lt",
	"name" => "lithuanian",
	"message" => "Lithuanian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2002-11-20", # 1992-03-04, for the content?
	"authors"       => ["vytas_statulevicius", "yannis_haralambous", "sigitas_tolusis"],
	# "licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Lithuanian in L7X and UTF-8 encodings.",
		# "Designed for \\lefthyphenmin and \\righthyphenmin set to 2.",
		"\\lefthyphenmin and \\righthyphenmin have to be at least 2.",
		# "Changing them to 1 according to grammatical rules from 1997",
		# "would require to review and maybe rebuild the patterns."
	],
},
# latvian
{
	"code" => "lv",
	"name" => "latvian",
	"message" => "Latvian hyphenation patterns",

	"version"       => "0.3",
	"last_modified" => "2005-09-14",
	"type"          => "dictionary",
	"authors"       => ["janis_vilims"],
	"licence"       => "LGPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Latvian in L7X and UTF-8 encodings.",
	],
},
# dutch
{
	"code" => "nl",
	"name" => "dutch",
	"filename_old_patterns" => "nehyph96.tex",
	# quoting Hans Hagen:
	# patterns generated with 2,2 (so don't go less) but use prefered values 2,3 (educational publishers want 4,5 -)
	"message" => "Dutch hyphenation patterns",

	"version"       => "1.1",
	"last_modified" => "1996-11",
	"type"          => "dictionary",
	"authors"       => ["piet_tutelaers"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Dutch in T1/EC and UTF-8 encodings.",
		# "\\lefthyphenmin and \\righthyphenmin must both be > 1.",
		"These patterns don't handle cases like 'menuutje' > 'menu-tje',",
		"and don't hyphenate words that have different hyphenations according",
		"to their meaning."
	],
},
# occitan
{
	"code" => "oc",
	"name" => "occitan",
	"message" => "Occitan hyphenation patterns",

	"version"       => "0.1",
	"last_modified" => "2016-02-04",
	"type"          => "rules",
	"authors"       => [ "claudio_beccari" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Occitan in T1/EC and UTF-8 encodings.",
		"They are supposed to be valid for all the Occitan variants",
		"spoken and written in the wide area called 'Occitanie' by the French.",
		"It ranges from the Val d'Aran within Catalunya, to the South Western",
		"Italian Alps encompassing the southern half of the French pentagon.",
	],
},
# polish
{
	"code" => "pl",
	"name" => "polish",
	"filename_old_patterns" => "plhyph.tex",
	#{}"hyphenmin" => [1,1],
	"message" => "Polish hyphenation patterns",

	"version"       => "3.0a",
	"last_modified" => "1995-06-17",
	"type"          => "dictionary",
	"authors"       => ["hanna_kolodziejska", "boguslaw_jackowski", "marek_rycko"],
	"licence"       => "public", # TODO Knuthian type
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Polish in QX and UTF-8 encodings.",
		"These patterns are also used by Polish TeX formats MeX and LaMeX.",
	],
},
# portuguese
# =portuges
{
	"code" => "pt",
	"name" => "portuguese", "synonyms" => ["portuges"],
	"filename_old_patterns" => "pthyph.tex",
	"message" => "Portuguese hyphenation patterns",

	"version"       => "1.0",
	"last_modified" => "1996-07-21",
	"type"          => "rules", # TODO: we could create a generating script
	"authors"       => ["pedro_j_de_rezende", "j_joao_dias_almeida"],
	"licence"       => "BSD-3",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Portuguese in T1/EC and UTF-8 encodings.",
	],
},
# pinyin
{
	"code" => "zh-latn-pinyin",
	"name" => "pinyin",
	"filename_old_patterns" => "pyhyph.tex",
	"message" => "Hyphenation patterns for unaccented pinyin syllables",

	"version"       => "4.8.0",
	"last_modified" => "2008-05-22",
	"type"          => "rules", # TODO: we could create a generating script
	"authors"       => ["werner_lemberg"],
	"licence"       => "GPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for unaccented transliterated Mandarin Chinese",
		"(pinyin) in T1/EC and UTF-8 encodings.",
	],
},
# romanian
{
	"code" => "ro",
	"name" => "romanian",
	"filename_old_patterns" => "rohyphen.tex",
	"message" => "Romanian hyphenation patterns", # : `rohyphen' 1.1 <29.10.1996>

	"version"       => "1.1R",
	"last_modified" => "1996-11-07",
	"type"          => "dictionary",
	"authors"       => ["adrian_rezus"],
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Romanian in T1/EC and UTF-8 encodings.",
		"The UTF-8 patterns use U+0219 for the character 's with comma accent'",
		"and U+021B for 't with comma accent', but we may consider using U+015F",
		"and U+0163 as well in the future.",
		# "Generated by PatGen2-output hyphen-level 9.",
	],
},
# slovenian
# =slovene
{
	"code" => "sl",
	"name" => "slovenian", "synonyms" => ["slovene"],
	"filename_old_patterns" => "sihyph.tex",
	"message" => "Slovenian hyphenation patterns",

	"version"       => "2.3",
	"last_modified" => "1997-15-04",
	"type"          => "dictionary",
	"authors"       => [ "matjaz_vrecko" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Slovenian in T1/EC and UTF-8 encodings.",
	],
},
# uppersorbian
{
	"code" => "hsb",
	"name" => "uppersorbian",
	"filename_old_patterns" => "sorhyph.tex",
	"message" => "Upper Sorbian hyphenation patterns",
#	\message{Hyphenation patterns for Upper Sorbian, E. Werner}
#	\message{Completely new revision 1997, March 22}

	"version"       => nil,
	"last_modified" => "1997-03-22",
	"authors"       => ["eduard_werner"],
	"type"          => "dictionary",
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Upper Sorbian in T1/EC and UTF-8 encodings.",
	],
},
# swedish
{
	"code" => "sv",
	"type"          => "dictionary",
},
# turkmen
{
	"code" => "tk",
	"name" => "turkmen",
	"filename_old_patterns" => nil,
	"message" => "Turkmen hyphenation patterns",

	"version"       => "0.1",
	"last_modified" => "2010-03-16",
	"type"          => "dictionary",
	"authors"       => [ "nazar_annagurban" ],
	"licence"       => "public",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Turkmen in T1/EC and UTF-8 encodings.",
	],
},
# turkish
{
	"code" => "tr",
	"name" => "turkish",
	"filename_old_patterns" => "tkhyph.tex",
	"message" => "Turkish hyphenation patterns",

	"version" => nil,
	"last_modified" => "2008-06-28",
	"type"          => "rules",
	"authors"       => ["pierre_mackay", "h_turgut_uyar", "s_ekin_kocabas", "mojca_miklavec"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Turkish in T1/EC and UTF-8 encodings.",
		# "Auto-generated from a script included in the distribution.",
		"The patterns for Turkish were first produced for the Ottoman Texts",
		"Project in 1987 and were suitable for both Modern Turkish and Ottoman",
		"Turkish in Latin script, however the required character set didn't fit",
		"into EC encoding, so support for Ottoman Turkish had to be dropped to",
		"keep compatibility with 8-bit engines.",
	]
},




# ukenglish
{
	"code" => "en-gb",
	"name" => "ukenglish", "synonyms" => ["british", "UKenglish"],
	"filename_old_patterns" => "ukhyphen.tex",
	"message" => "Hyphenation patterns for British English", # FIXME Inconsistent

	"version"       => "1.0a", # FIXME a much older comment says 2.0?
	"last_modified" => "2005-10-18",
	"type"          => "dictionary",
	"authors"       => ["dominik_wujastyk", "graham_toal"],
	"licence"       => "other-free", # TODO Knuth-like
	# (This will be uncommented during reimplementation)
	# "description_s" => "British English hyphenation patterns",
	# "description_l" => [
	# 	"Hyphenation patterns for British English in ASCII encoding.",
	# ],

	"description_l" => [
		#......................................................................#
		"Additional hyphenation patterns for American and British",
		"English in ASCII encoding.  The American English patterns",
		"(usenglishmax) greatly extend the standard patterns from Knuth",
		"to find many additional hyphenation points.  British English",
		"hyphenation is completely different from US English, so has its",
		"own set of patterns.",
	],
},
# (US english)
# usenglishmax
{
	"code" => "en-us",
	"name" => "usenglishmax",
	"filename_old_patterns" => "ushyphmax.tex",
	"message" => "Hyphenation patterns for American English", # FIXME Consistent

	"version"       => nil,
	"last_modified" => "1990-03-01", # 8-bit file also has version 2005-05-30.
	"type"          => "dictionary",
	"authors"       => ["donald_e_knuth", "gerard_d_c_kuiken"],
	"licence"       => "other-free",
	# (This will be uncommented during reimplementation)
	# "description_s" => "American English hyphenation patterns",
	# "description_l" => [
	# 	"Hyphenation patterns for American English in ASCII encoding.",
	# ],
},
# US english
# {
# 	"code" => "en-us-x-knuth",
# 	"name" => "english",
# 	"use_new_loader" => false,
# 	"use_old_patterns" => false,
# 	"filename_old_patterns" => "hyphen.tex",
# 	"hyphenmin" => [2,3], # confirmed, same as what Knuth says
# 	"encoding" => "ascii",
# 	"exceptions" => true,
# 	"message" => "Hyphenation patterns for American English",
# },
# TODO: FIXME!!!
# serbian
{
	"code" => "sh-latn",
	"name" => "serbian",
	"filename_old_patterns" => "shhyphl.tex",
	# It is allowed to leave one character at the end of the row.
	# However, if you think that it is graphicaly not very
	# pleasant these patterns will work well with \lefthyphenmin=2.
	# \lefthyphenmin=1 \righthyphenmin=2
	"message" => "Serbian hyphenation patterns in Latin script",

	# only for serbian
	"version"       => "2.02",
	"last_modified" => "2008-06-22",
	"type"          => "dictionary",
	"authors"       => [ "dejan_muhamedagic" ],
	"licence"       => "LPPL",
	# for both scripts
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Serbian in T1/EC, T2A and UTF-8 encodings.",
		"For 8-bit engines the patterns are available separately as 'serbian'",
		"in T1/EC encoding for Latin script and 'serbianc' in T2A encoding for",
		"Cyrillic script. Unicode engines should only use 'serbian'",
		"which has patterns in both scripts combined.",
	],
},
# serbianc
{
	"code" => "sh-cyrl",
	"name" => "serbianc",
	# "filename_old_patterns" => "srhyphc.tex",
	"message" => "Serbian hyphenation patterns in Cyrillic script",
},
# FIXME Remove later
{
	"code" => "sr-cyrl",
	"name" => "serbiancalt",
},
# mongolian (used to be mongolian2a)
{
	"code" => "mn-cyrl",
	"name" => "mongolian",
	"filename_old_patterns" => "mnhyphn.tex",
	"message" => "(New) Mongolian hyphenation patterns",

	# only for this one
	"version"       => "1.2",
	"last_modified" => "2010-04-03",
	"type"          => "dictionary",
	"authors"       => [ "dorjgotov_batmunkh" ],
	"licence"       => "LPPL",
	# for both
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Mongolian in T2A, LMC and UTF-8 encodings.",
		"LMC encoding is used in MonTeX. The package includes two sets of",
		"patterns that will hopefully be merged in future.",
	],
},
# mongolianlmc	xu-mnhyph.tex (used to be mongolian)
{
	"code" => "mn-cyrl-x-lmc",
	"name" => "mongolianlmc",
	"filename_old_patterns" => "mnhyph.tex",
	"message" => "Mongolian hyphenation patterns",
},
# bulgarian
{
	"code" => "bg",
	"name" => "bulgarian",
	"filename_old_patterns" => "bghyphen.tex",
	"message" => "Bulgarian hyphenation patterns",

	"version"       => "1.7",
	"last_modified" => "2008-06",
	"type"          => "pattern",
	"authors"       => [ "georgi_boshnakov" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Bulgarian in T2A and UTF-8 encodings.",
	],
},
# sanskrit
{
	"code" => "sa",
	"name" => "sanskrit",
	"message" => "Sanskrit hyphenation patterns",

	"version"       => "0.6",
	"last_modified" => "2011-09-14",
	"type"          => "rules",
	"authors"       => ["yves_codet"],
	"licence"       => "free", # You may freely use, copy, modify and/or distribute this file.
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Sanskrit and Prakrit in transliteration,",
		"and in Devanagari, Bengali, Kannada, Malayalam and Telugu scripts",
		"for Unicode engines.",
	],
},
# norwegian
{
	"code" => "no",
	"name" => "norwegian", # TODO: fixme
	"message" => "Norwegian hyphenation patterns",
},
# norsk
{
	"code" => "nb",
	"name" => "bokmal", "synonyms" => ["norwegian", "norsk"],
	"message" => "Norwegian Bokmal hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2012-05-18",
	"type"          => "dictionary",
	"authors"       => [ "rune_kleveland", "ole_michael_selberg" ],
	"licence"       => "free", # TODO
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Norwegian Bokmal and Nynorsk in T1/EC and",
		"UTF-8 encodings.",
	],
},
# nynorsk
{
	"code" => "nn",
	"name" => "nynorsk",
	"message" => "Norwegian Nynorsk hyphenation patterns",
},
#####
# assamese
{
	"code" => "as",
	"name" => "assamese",
	"message" => "Assamese hyphenation patterns",

	# this is true for all Indic patterns
	"version"       => "0.9.0",
	"last_modified" => "2016-01-16",
	"type"          => "rules",
	"authors"       => ["santhosh_thottingal"],
	"licence"       => "MIT",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Assamese, Bengali, Gujarati, Hindi, Kannada,",
		"Malayalam, Marathi, Oriya, Panjabi, Tamil and Telugu for Unicode",
		"engines.",
	],
},
# bengali
{
	"code" => "bn",
	"name" => "bengali",
	"message" => "Bengali hyphenation patterns",
},
# gujarati
{
	"code" => "gu",
	"name" => "gujarati",
	"message" => "Gujarati hyphenation patterns",
},
# hindi
{
	"code" => "hi",
	"name" => "hindi",
	"message" => "Hindi hyphenation patterns",
},
# kannada
{
	"code" => "kn",
	"name" => "kannada",
	"message" => "Kannada hyphenation patterns",
},
# malayalam
{
	"code" => "ml",
	"name" => "malayalam",
	"message" => "Malayalam hyphenation patterns",
},
# marathi
{
	"code" => "mr",
	"name" => "marathi",
	"message" => "Marathi hyphenation patterns",
},
# oriya
{
	"code" => "or",
	"name" => "oriya",
	"message" => "Oriya hyphenation patterns",
},
# panjabi
{
	"code" => "pa",
	"name" => "panjabi",
	"message" => "Panjabi hyphenation patterns",
},
# tamil
{
	"code" => "ta",
	"name" => "tamil",
	"message" => "Tamil hyphenation patterns",
},
# telugu
{
	"code" => "te",
	"name" => "telugu",
	"message" => "Telugu hyphenation patterns",
},
# thai
{
	"code" => "th",
	"name" => "thai",
	"message" => "Thai hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2015-05-07",
	"type"          => "dictionary",
	"authors"       => [ "theppitak_karoonboonyanan" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Thai in LTH and UTF-8 encodings.",
	],
},
# lao
#{
#	"code" => "lo",
#	"name" => "lao",
#	"use_new_loader" => true,
#	"use_old_patterns" => false,
#	"hyphenmin" => [1,1], # TODO
#	"encoding" => nil, # no patterns for 8-bit engines
#	"exceptions" => false,
#	"message" => "Lao hyphenation patterns",
#
#	"version"       => nil,
#	"last_modified" => "2010-05-19",
#	"type"          => "rules",
#	"authors"       => [ "brian_wilson", "arthur_reutenauer", "mojca_miklavec" ],
#	"licence"       => "other-free",
#	"description_s" => "Lao hyphenation patterns",
#	"description_l" => [
#		#......................................................................#
#		"Hyphenation patterns for Lao language for Unicode engines.",
#		"Current version is experimental and gives bad results.",
#	],
#},
# pan-Ethiopic
{
	"code" => "mul-ethi",
	"name" => "ethiopic", "synonyms" => ["amharic", "geez"],
	"version" => nil,
	"last_modified" => "2011-01-10",
	"authors" => ["arthur_reutenauer", "mojca_miklavec"],
	"licence" => "public-ask", # TODO
	"message" => "Pan-Ethiopic hyphenation patterns",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for languages written using the Ethiopic script",
		"for Unicode engines. They are not supposed to be linguistically",
		"relevant in all cases and should, for proper typography, be replaced",
		"by files tailored to individual languages.",
	],
},
# georgian
{
	"code" => "ka",
	"name" => "georgian",
	"message" => "Georgian hyphenation patterns",

	"version"       => "0.3",
	"last_modified" => "2013-04-15",
	"type"          => "dictionary",
	"authors"       => [ "levan_shoshiashvili" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Georgian in T8M, T8K and UTF-8 encodings.",
	],
},
# Church Slavonic
{
	"code" => "cu",
	"name" => "churchslavonic",
	"message" => "Church Slavonic hyphenation patterns",

	"version" => nil,
	"last_modified" => "2016-04-16",
	"type" => "machine learning",
	"authors" => ["mike_kroutikov", "aleksandr_andreev"],
	"licence" => "MIT",
	"description_l" => [
		"Hyphenation patterns for Church Slavonic in UTF-8 encoding",
	],
},
# Belarusian
{
	"code" => "be",
	"name" => "belarusian",
	"message" => "Belarusian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2016-09-29",
	"type"          => "rules",
	"authors"       => ["maksim_salau"],
	"licence"       => "MIT",
	"description_l" => [
		"Belarusian hyphenation patterns in T2A and UTF-8 encodings"
	],
},
# Pali
{
	"code" => "pi",
	"name" => "pali",
	# no encoding
	"message" => "Pali hyphenation patterns",
	# no version number
	"last_modified" => "2018-06-29",
	"type" => "rules",
	"authors" => ["wie_ming_ang"],
	"licence" => "MIT",
	"description_l" => [
		"Pali hyphenation patterns in UTF-8 encoding",
	],
},
# dumylang -> dumyhyph.tex
# nohyphenation -> zerohyph.tex
# arabic -> zerohyph.tex
# farsi zerohyph.tex
# =persian
	]
end
