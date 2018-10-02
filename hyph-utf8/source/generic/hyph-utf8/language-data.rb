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
{
	"code" => "sh-cyrl",
},
{
	"code" => "mn-cyrl",
        "type"          => "dictionary",
	"last_modified" => "2010-04-03", # FIXME: ?
},
{
	"code" => "sa",
        "type"          => "rules",
},
{
	"code" => "nb",
        "type"          => "dictionary",
        "last_modified" => "2012-05-18", # FIXME: ?
},
{
	"code" => "as",
	# this is true for all Indic patterns
	"type"          => "rules",
},
# thai
{
	"code" => "th",
        "type"          => "dictionary",
        "last_modified" => "2015-05-07", # FIXME: ?
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
{
	"code" => "ka",
        "type"          => "dictionary",
},
{
	"code" => "cu",
        "type" => "machine learning",
},
{
	"code" => "be",
        "type"          => "rules",
},
{
	"code" => "pi",
	"type" => "rules",
},
	]
end
