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
{
	"code" => "gl",
	"type"          => "rules",
},
{
	"code" => "et",
        "type"          => "dictionary",
},
{
	"code" => "fi",
        "type"          => "rules",
},
{
	"code" => "hr",
        "type"          => "dictionary",
},
{
	"code" => "hu",
        "type"          => "dictionary",
        "source" => "https://github.com/nagybence/huhyphn/", # FIXME Check and remove from desc below
},
{
	"code" => "hy",
        "type"          => "rules",
},
{
	"code" => "ia",
        "type"          => "dictionary",
},
{
	"code" => "id",
        "type"          => "rules",
},
{
	"code" => "is",
        "type"          => "dictionary",
	# TODO: I'm not sure that the last two names are relevant, I don't find the source of Marteinn Sverrisson
	"authors"       => ["jorgen_pind", "marteinn_sverrisson", "kristinn_gylfason"],
},
{
	"code" => "ga",
        "type"          => "dictionary",
},
{
	"code" => "it",
	"type"          => "rules", # TODO: we might want to check that, but it seems unlikely that patgen was used
},
{
	"code" => "rm",
        "type"          => "rules",
},
{
	"code" => "fur",
        "type"          => "rules",
},
{
	"code" => "pms",
        "type"          => "rules",
},
{
	"code" => "kmr",
        "type"          => "dictionary",
},
{
	"code" => "la",
        "type"          => "rules",
},
{
	"code" => "la-x-classic",
        "type"          => "rules",
},
{
	"code" => "la-x-liturgic",
	"version"       => "1.040",
	"last_modified" => "2016-05-19",
	"type"          => "rules",
},
{
	"code" => "lt",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Lithuanian in L7X and UTF-8 encodings.",
		# "Designed for \\lefthyphenmin and \\righthyphenmin set to 2.",
		"\\lefthyphenmin and \\righthyphenmin have to be at least 2.",
		# "Changing them to 1 according to grammatical rules from 1997",
		# "would require to review and maybe rebuild the patterns."
	],
},
{
	"code" => "lv",
        "type"          => "dictionary",
},
{
	"code" => "nl",
        "type"          => "dictionary",
        # quoting Hans Hagen:
        # patterns generated with 2,2 (so don't go less) but use prefered values 2,3 (educational publishers want 4,5 -)
},
{
	"code" => "oc",
        "type"          => "rules",
},
{
	"code" => "pl",
        "type"          => "dictionary",
        #{}"hyphenmin" => [1,1],
},
{
	"code" => "pt",
        "type"          => "rules", # TODO: we could create a generating script
},
{
	"code" => "zh-latn-pinyin",
        "type"          => "rules", # TODO: we could create a generating script
},
{
	"code" => "ro",
        "type"          => "dictionary",
},
{
	"code" => "sl",
	"type"          => "dictionary",
},
{
	"code" => "hsb",
        "type"          => "dictionary",
},
{
	"code" => "sv",
	"type"          => "dictionary",
},
{
	"code" => "tk",
        "type"          => "dictionary",
},
{
	"code" => "tr",
        "type"          => "rules",
},
{
	"code" => "en-gb",
        "type"          => "dictionary",
},
{
	"code" => "en-us",
},
# TODO: FIXME!!!
{
	"code" => "sh-latn",
        "type"          => "dictionary",
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
