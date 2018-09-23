class Language
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
# --------------------------------------
# languages with no hyphenation patterns
# --------------------------------------
# arabic
{
	"code" => "ar",
	"name" => "arabic",
	"use_old_loader" => true,
	"filename_old_patterns" => "zerohyph.tex",
#	"hyphenmin" => [], # not needed
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,

	# TODO
	"description_l" => [
		#......................................................................#
		"Prevent hyphenation in Arabic.",
	],
},
# farsi
# =persian
{
	"code" => "fa",
	"name" => "farsi", "synonyms" => ["persian"],
	"use_old_loader" => true,
	"filename_old_patterns" => "zerohyph.tex",
#	"hyphenmin" => [], # not needed
	"encoding" => nil,
	"exceptions" => false,
	"message" => nil,

	# TODO
	"description_l" => [
		#......................................................................#
		"Prevent hyphenation in Persian.",
	],
},
# ----------------------------
# languages using old patterns
# ----------------------------
# greek
# =polygreek
# monogreek
{
	"code" => "el-monoton",
	"name" => "monogreek",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "Old patterns work in a different way, one-to-one conversion from UTF-8 is not possible.",
	"filename_old_patterns" => "grmhyph5.tex",
	"hyphenmin" => [1,1], # polyglossia
	"encoding" => nil,
	"exceptions" => true,
	"message" => "Hyphenation patterns for uni-accent (monotonic) Modern Greek",

	"version"       => "5.0",
	"last_modified" => "2008-06-06",
	"type"          => "rules",
	"authors"       => ["dimitrios_filippou"],
	"licence"       => "LPPL",
	# "description_s" => "Monotonic Modern Greek hyphenation patterns",
	# "description_l" => [
	# 	#......................................................................#
	# 	"Hyphenation patterns for Modern Greek in monotonic spelling.",
	# 	"The pattern file used for 8-bit engines is grmhyph5.tex, in Babel's LGR encoding,",
	# 	"that is not part of hyph-utf8.",
	# 	"Patterns in UTF-8 use two code positions for each of the vowels with acute accent",
	# 	"(a.k.a tonos, oxia), e.g., U+03AD, U+1F73 for epsilon.",
	# ],
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Modern Greek in monotonic and polytonic",
		"spelling in LGR and UTF-8 encodings.  Patterns in UTF-8 use two code",
		"positions for each of the vowels with acute accent (a.k.a tonos,",
		"oxia), e.g., U+03AC, U+1F71 for alpha.",
	],
},
{
	"code" => "el-polyton",
	"name" => "greek", "synonyms" => ["polygreek"],
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "Old patterns work in a different way, one-to-one conversion from UTF-8 is not possible.",
	"filename_old_patterns" => "grphyph5.tex",
	# left/right hyphen min for Greek can be as low as one (1),
	# but for aesthetic reasons keep them at 2/2.
	# Dimitrios Filippou
	"hyphenmin" => [1,1], # polyglossia
	"encoding" => nil,
	"exceptions" => true,
	"message" => "Hyphenation patterns for multi-accent (polytonic) Modern Greek",

	"version"       => "5.0",
	"last_modified" => "2008-06-06",
	"type"          => "rules",
	"authors"       => ["dimitrios_filippou"],
	"licence"       => "LPPL",
	# "description_s" => "Polytonic Modern Greek hyphenation patterns",
	# #                  #.....................................................................#
	# "description_l" => [
	# 	#......................................................................#
	# 	"Hyphenation patterns for Modern Greek in polytonic spelling.",
	# 	"The pattern file used for 8-bit engines is grphyph5.tex that is",
	# 	"not part of hyph-utf8. Patterns in UTF-8 use two code positions for",
	# 	"each of the vowels with acute accent (a.k.a tonos, oxia), e.g.,",
	# 	"U+03AC, U+1F71 for alpha.",
	# ],
},
# ancientgreek
{
	"code" => "grc",
	"name" => "ancientgreek",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "Old patterns work in a different way, one-to-one conversion from UTF-8 is not possible.",
	"filename_old_patterns" => "grahyph5.tex",
	"hyphenmin" => [1,1], # polyglossia
	"encoding" => nil,
	"exceptions" => false,
	"message" => "Hyphenation patterns for Ancient Greek",

	"version"       => "5.0",
	"last_modified" => "2016-05-12",
	"type"          => "rules",
	"authors"       => ["dimitrios_filippou"],
	"licence"       => "LPPL",
	# "description_s" => "Ancient Greek hyphenation patterns",
	# "description_l" => [
	# 	#......................................................................#
	# 	"Hyphenation patterns for Ancient Greek.",
	# 	"The pattern file used for 8-bit engines is grahyph5.tex, in Babel's LGR encoding,",
	# 	"that is not part of hyph-utf8.",
	# 	"Patterns in UTF-8 use two code positions for each of the vowels with acute accent",
	# 	"(a.k.a tonos, oxia), e.g., U+03AE, U+1F75 for eta.",
	# ],
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Ancient Greek in LGR and UTF-8 encodings,",
		"including support for (obsolete) Ibycus font encoding.",
		"Patterns in UTF-8 use two code positions for each of the vowels with",
		"acute accent (a.k.a tonos, oxia), e.g., U+03AE, U+1F75 for eta.",
	],
},
# -------------------------------
# special patterns, not converted
# -------------------------------
# ibycus ibyhyph.tex
{
	"code" => "grc-x-ibycus",
	"name" => "ibycus",
	"use_old_patterns" => true,
	"use_old_loader" => true,
	"filename_old_patterns" => "ibyhyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => nil,
	"exceptions" => false,
	"message" => "Ancient Greek hyphenation patterns for Ibycus encoding",

	# "authors" => ["peter_heslin"],
	"version" => 3.0,
},
# ----------------------------------------------------------
# more languages using old patterns (see el-* and grc above)
# ----------------------------------------------------------
# coptic
{
	"code" => "cop",
	"name" => "coptic",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "TODO: automatic conversion could be done, but was too complicated; leave for later.",
	"filename_old_patterns" => "copthyph.tex",
	"hyphenmin" => [1,1], # polyglossia TODO: no documentation found
	"encoding" => nil,
	"exceptions" => false,
	"message" => "Coptic hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2004-10-03",
	"type"          => "rules",
	"authors"       => [ "claudio_beccari" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Coptic in UTF-8 encoding",
		"as well as in ASCII-based encoding for 8-bit engines.",
		"The latter can only be used with special Coptic fonts (like CBcoptic).",
		"The patterns are considered experimental.",
	],
},
# german
{
	"code" => "de-1901",
	"name" => "german",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "Kept for the sake of backward compatibility, but newer and better patterns by WL are available.",
	"filename_old_patterns" => "dehypht.tex",
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "German hyphenation patterns (traditional orthography)",

	"version"       => "0.40",
	"last_modified" => "2014-05-21", # For the active project
	"type"          => "dictionary",
	"authors"       => ["werner_lemberg"],
	"licence"       => "LPPL",
	# "description_s" => "German hyphenation patterns in traditional spelling",
	# "description_l" => [
	# 	"Hyphenation patterns for German in traditional spelling, in T1/EC and UTF-8 encoding.",
	# 	"Patterns encoded in UTF-8 are provided by a separate package.",
	# ],

	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for German in T1/EC and UTF-8 encodings,",
		"for traditional and reformed spelling, including Swiss German.",
		"The package includes the latest patterns from dehyph-exptl",
		"(known to TeX under names 'german', 'ngerman' and 'swissgerman'),",
		"however 8-bit engines still load old versions of patterns",
		"for 'german' and 'ngerman' for backward-compatibility reasons.",
		"Swiss German patterns are suitable for Swiss Standard German",
		"(Hochdeutsch) not the Alemannic dialects spoken in Switzerland",
		"(Schwyzerduetsch).",
		"There are no known patterns for written Schwyzerduetsch.",
	]
},
# ngerman
{
	"code" => "de-1996",
	"name" => "ngerman",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "Kept for the sake of backward compatibility, but newer and better patterns by WL are available.",
	"filename_old_patterns" => "dehyphn.tex",
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "German hyphenation patterns (reformed orthography)",

	"version"       => "0.40",
	"last_modified" => "2014-05-21", # For the active project
	"type"          => "dictionary",
	"authors"       => ["werner_lemberg"],
	"licence"       => "LPPL",
	# "description_s" => "German hyphenation patterns in reformed spelling",
	# "description_l" => [
	# 	"Hyphenation patterns for German in reformed spelling, in T1/EC and UTF-8 encoding.",
	# 	"Patterns encoded in UTF-8 are provided by a separate package.",
	# ],
},
# swissgerman
{
	"code" => "de-ch-1901",
	"name" => "swissgerman",
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Swiss-German hyphenation patterns (traditional orthography)",

	"version"       => "0.40",
	"last_modified" => "2014-05-21", # For the active project
	"type"          => "dictionary",
	"authors"       => ["werner_lemberg"],
	"licence"       => "LPPL",
	# "description_l" => "German hyphenation patterns, traditional spelling in Switzerland.",
	# "description_s" => [
	# 	"Hyphenation patterns for German in traditional spelling as used in Switzerland, in T1/EC and UTF-8.",
	# 	"These patterns are suitable for Standard German (Hochdeutsch), not the Alemannic dialects",
	# 	"spoken in Switzerland (Schwyzerdütsch).  There are no patterns for written Schwyzerdütsch",
	# 	"we know of.",
	# ],
},
# russian
{
	"code" => "ru",
	"name" => "russian",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "The old system allows choosing patterns and encodings manually. That mechanism needs to be implemented first in this package, so we still fall back on old system.",
	"filename_old_patterns" => "ruhyphen.tex",
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Russian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2003-03-10", # Date of the patterns proper, not the support files
	"type"          => "dictionary",
	"authors"       => ["alexander_i_lebedev", "werner_lemberg", "vladimir_volovich"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Russian in T2A and UTF-8 encodings.",
		"For 8-bit engines, the 'ruhyphen' package provides a number of",
		"different pattern sets, as well as different (8-bit) encodings, that",
		"can be chosen at format-generation time.  The UTF-8 version only",
		"provides the default pattern set.  A mechanism similar to the one used",
		"for 8-bit patterns may be implemented in the future.",
	],
},
# ukrainian
{
	"code" => "uk",
	"name" => "ukrainian",
	"use_old_patterns" => true,
	"use_old_patterns_comment" => "The old system allows choosing patterns and encodings manually. That mechanism needs to be implemented first in this package, so we still fall back on old system.",
	"filename_old_patterns" => "ukrhyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => false,
	"message" => "Ukrainian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2001-05-10", # Date of the patterns proper
	# "type"          => "rules", # TODO: it is not really clear
	"authors"       => ["maksym_polyakov", "werner_lemberg", "vladimir_volovich"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Ukrainian in T2A and UTF-8 encodings.",
		"For 8-bit engines, the 'ukrhyph' package provides a number of",
		"different pattern sets, as well as different (8-bit) encodings, that",
		"can be chosen at format-generation time.  The UTF-8 version only",
		"provides the default pattern set.  A mechanism similar to the one used",
		"for 8-bit patterns may be implemented in the future.",
	],
},
# ----------------------------
# languages using new patterns
# ----------------------------
# afrikaans
{
	"code" => "af",
	"name" => "afrikaans",
	"filename_old_patterns" => nil,
	"hyphenmin" => [1,2], # in babel: 2,2
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Afrikaans hyphenation patterns",

	"version"       => "1.0",
	"last_modified" => "2013-10-08",
	"type"          => "dictionary",
	"authors"       => [ "tilla_fick", "chris_swanepoel" ],
	"email"         => [ "hyphen{at}rekenaar{dot}net" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Afrikaans in T1/EC and UTF-8 encodings.",
		"OpenOffice includes older patterns created by a different author,",
		"but the patterns packaged with TeX are considered superior in quality.",
		# "Word list used to generate patterns with opatgen might be released in future.",
	],
},
# catalan
{
	"code" => "ca",
	"name" => "catalan",
	"filename_old_patterns" => "cahyph.tex",
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Catalan hyphenation patterns",

	"version"       => "1.11",
	"last_modified" => "2003-07-15",
	"type"          => "rules", # not only rules, also patgen, but it is a good approximation
	"authors"       => [ "goncal_badenes" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Catalan in T1/EC and UTF-8 encodings.",
	],
},
# czech
{
	"code" => "cs",
	"name" => "czech",
	"filename_old_patterns" => "czhyph.tex",
	"filename_old_patterns_other" => ["czhyphen.tex","czhyphen.ex"],
	# Both Czech and Slovak: \lefthyphenmin=2, \righthyphenmin=3
	# Typographical rules allow \righthyphenmin=2 when typesetting in a
	# narrow column (newspapers etc.).
	# (used to be 2,2)
	"hyphenmin" => [2,3],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Czech hyphenation patterns",

	"version"       => "3",
	# guessing based on CTAN/macros/cstex/base/csplain.tar.gz:
	# 1998-12-17 (patterns)
	# 1995-08-23 (exceptions)
	# but patterns claim 1995
	"last_modified" => "1995", # todo: no date
	"type"          => "dictionary",
	"authors"       => [ "pavel_sevecek" ],
	"licence"       => "GPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Czech in T1/EC and UTF-8 encodings.",
		"Original patterns 'czhyphen' are still distributed in the 'csplain'",
		"package and loaded with ISO Latin 2 encoding (IL2).",
		# however hyph-utf8 could also be used for that
	],
},
# slovak
{
	"code" => "sk",
	"name" => "slovak",
	"filename_old_patterns" => "skhyph.tex",
	"filename_old_patterns_other" => ["skhyphen.tex","skhyphen.ex"],
	# see czech
	"hyphenmin" => [2,3],
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Slovak hyphenation patterns",

	"version"       => "2",
	"last_modified" => "1992-04-24",
	"type"          => "dictionary",
	"authors"       => [ "jana_chlebikova" ],
	"licence"       => "GPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Slovak in T1/EC and UTF-8 encodings.",
		"Original patterns 'skhyphen' are still distributed in the 'csplain'",
		"package and loaded with ISO Latin 2 encoding (IL2).",
		# however hyph-utf8 could also be used for that
	],
},
# welsh
{
	"code" => "cy",
	"name" => "welsh",
	"filename_old_patterns" => "cyhyph.tex",
	"hyphenmin" => [2,3],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Welsh hyphenation patterns",

	"version"       => nil,
	"last_modified" => "1996",
	"type"          => "dictionary",
	"authors"       => [ "yannis_haralambous" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Welsh in T1/EC and UTF-8 encodings.",
	],
},
# danish
{
	"code" => "da",
	"name" => "danish",
	"filename_old_patterns" => "dkhyph.tex",
	"filename_old_patterns_other" => ["dkcommon.tex", "dkspecial.tex"],
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Danish hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2011-01-11",
	"type"          => "dictionary",
	"authors"       => [ "frank_jensen" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Danish in T1/EC and UTF-8 encodings.",
	],
},
# esperanto
{
	"code" => "eo",
	"name" => "esperanto",
	"filename_old_patterns" => "eohyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "il3", # TODO
	"exceptions" => false,
	"message" => "Esperanto hyphenation patterns",

	"version"       => nil,
	"last_modified" => "1999-08-10",
	"type"          => "rules",
	"authors"       => [ "sergei_pokrovsky" ],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Esperanto ISO Latin 3 and UTF-8 encodings.",
		"Note that TeX distributions don't ship any suitable fonts in Latin 3",
		"encoding, so unless you create your own font support or want to use",
		"MlTeX, using native Unicode engines is highly recommended.",
		# "Hyphenation patterns for Esperanto ISO Latin 3 and UTF-8 encodings.",
		# "Note that TeX distributions usually don't ship any suitable fonts in",
		# "Latin 3 encoding, so unless you create your own font support or want",
		# "to use MlTeX, using native UTF-8 engines is highly recommended.",
	],
},
# spanish
# =espanol
{
	"code" => "es",
	"name" => "spanish", "synonyms" => ["espanol"],
	"filename_old_patterns" => "eshyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Spanish hyphenation patterns",

	"version"       => "4.7",
	"last_modified" => "2015-11-12",
	"type"          => "dictionary",
	"authors"       => [ "javier_bezos" ],
	"licence"       => "MIT/X11",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Spanish in T1/EC and UTF-8 encodings.",
	],
},
# basque
{
	"code" => "eu",
	"name" => "basque",
	"filename_old_patterns" => "bahyph.tex",
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Basque hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2008-06-26",
	"type"          => "rules",
	"authors"       => [ "juan_aguirregabiria" ],
	"licence"       => "other-free", # "public-check",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Basque in T1/EC and UTF-8 encodings.",
		# "Generating scripts for these rule-based patterns is included in hyph-utf8."
	],
},
# french
# =patois
# =francais
{
	"code" => "fr",
	"name" => "french", "synonyms" => ["patois","francais"],
	"filename_old_patterns" => "frhyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "French hyphenation patterns",

	"version"       => "2.13",
	"last_modified" => "2016-05-12",
	"type"          => "rules",
	"authors"       => ["daniel_flipo", "bernard_gaulle", "arthur_reutenauer"],
	"email"         => ["cesure-l{at}gutenberg{dot}eu{dot}org"],
	"licence"       => "MIT",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for French in T1/EC and UTF-8 encodings.",
	]
},
# galician
{
	"code" => "gl",
	"name" => "galician",
	"filename_old_patterns" => "glhyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Galician hyphenation patterns",

	"version"       => "2.4",
	"last_modified" => "2010-04-23",
	"type"          => "rules",
	"authors"       => ["javier_mugica"],
	"licence"       => "LPPL", # Status maintained
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Galician in T1/EC and UTF-8 encodings.",
		# "Generated automatically from the mkpattern utility.",
	]
},
# estonian
{
	"code" => "et",
	"name" => "estonian",
	"filename_old_patterns" => "ethyph.tex",
	"hyphenmin" => [2,3], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Estonian hyphenation patterns",

	"version"       => nil,
	"last_modified" => "2004-04-13",
	"type"          => "dictionary",
	"authors"       => [ "een_saar" ],
	"licence"       => "LPPL|MIT", # Dual MIT-LPPL
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Estonian in T1/EC and UTF-8 encodings.",
	],
},
# finnish
{
	"code" => "fi",
	"name" => "finnish",
	"filename_old_patterns" => "fihyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2], # polyglossia
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [1,2], # taken from Hyphenator.js; check the value
	"encoding" => nil,
	"exceptions" => false,
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
	"hyphenmin" => [2,2], # babel
	"encoding" => "ascii",
	"exceptions" => true,
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
	"hyphenmin" => [2,2],
	"encoding" => "ascii",
	"exceptions" => true,
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
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,3], # babel
	"encoding" => "ec",
	"exceptions" => true,
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
	"hyphenmin" => [2,2], # babel
	"encoding" => "ascii",
	"exceptions" => false,
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
	"hyphenmin" => [2,2], # todo
	"encoding" => "ascii",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ascii",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ascii",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "l7x",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "l7x",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "qx",
	"exceptions" => true,
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
	"hyphenmin" => [2,3], # babel
	"encoding" => "ec",
	"exceptions" => true,
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
	"hyphenmin" => [1,1],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"name" => "upper sorbian",
	"filename_old_patterns" => "sorhyph.tex",
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
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
	"name" => "swedish",
	"filename_old_patterns" => "svhyph.tex",
	"hyphenmin" => [2,2], # patters say it could be 1,2; babel says 2,2 - double check
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Swedish hyphenation patterns",

	# "version"       => "1994-03-03", # that is what author used in message
	"version"       => nil,
	"last_modified" => "1994-03-03",
	"type"          => "dictionary",
	"authors"       => ["jan_michael_rynning"],
	"licence"       => "LPPL",
	"description_l" => [
		#......................................................................#
		"Hyphenation patterns for Swedish in T1/EC and UTF-8 encodings.",
	],
},
# turkmen
{
	"code" => "tk",
	"name" => "turkmen",
	"filename_old_patterns" => nil,
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,2], # polyglossia
	"encoding" => "ec",
	"exceptions" => false,
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
	"hyphenmin" => [2,3], # confirmed, same as what Knuth says
	"encoding" => "ascii",
	"exceptions" => true,
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
	"hyphenmin" => [2,3], # confirmed, same as what Knuth says
	"encoding" => "ascii",
	"exceptions" => true,
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
	"hyphenmin" => [2,2],
	"encoding" => "ec",
	"exceptions" => true,
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
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => true,
	"message" => "Serbian hyphenation patterns in Cyrillic script",
},
# mongolian (used to be mongolian2a)
{
	"code" => "mn-cyrl",
	"name" => "mongolian",
	"filename_old_patterns" => "mnhyphn.tex",
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
	"exceptions" => false,
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
	"hyphenmin" => [2,2],
	"encoding" => "lmc",
	"exceptions" => false,
	"message" => "Mongolian hyphenation patterns",
},
# bulgarian
{
	"code" => "bg",
	"name" => "bulgarian",
	"filename_old_patterns" => "bghyphen.tex",
	"hyphenmin" => [2,2], # babel
	"encoding" => "t2a",
	"exceptions" => false,
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
	"hyphenmin" => [1,3], # polyglossia
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
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
	"use_old_loader" => true,
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => false,
	"message" => "Norwegian hyphenation patterns",
},
# norsk
{
	"code" => "nb",
	"name" => "bokmal", "synonyms" => ["norwegian", "norsk"],
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => true,
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
	"hyphenmin" => [2,2], # babel
	"encoding" => "ec",
	"exceptions" => true,
	"message" => "Norwegian Nynorsk hyphenation patterns",
},
#####
# assamese
{
	"code" => "as",
	"name" => "assamese",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
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
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Bengali hyphenation patterns",
},
# gujarati
{
	"code" => "gu",
	"name" => "gujarati",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Gujarati hyphenation patterns",
},
# hindi
{
	"code" => "hi",
	"name" => "hindi",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Hindi hyphenation patterns",
},
# kannada
{
	"code" => "kn",
	"name" => "kannada",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Kannada hyphenation patterns",
},
# malayalam
{
	"code" => "ml",
	"name" => "malayalam",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Malayalam hyphenation patterns",
},
# marathi
{
	"code" => "mr",
	"name" => "marathi",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Marathi hyphenation patterns",
},
# oriya
{
	"code" => "or",
	"name" => "oriya",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Oriya hyphenation patterns",
},
# panjabi
{
	"code" => "pa",
	"name" => "panjabi",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Panjabi hyphenation patterns",
},
# tamil
{
	"code" => "ta",
	"name" => "tamil",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Tamil hyphenation patterns",
},
# telugu
{
	"code" => "te",
	"name" => "telugu",
	"hyphenmin" => [1,1], # TODO
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
	"message" => "Telugu hyphenation patterns",
},
# thai
{
	"code" => "th",
	"name" => "thai",
	"hyphenmin" => [2,3],
	"encoding" => "lth",
	"exceptions" => false,
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
	"hyphenmin" => [1,1],
	"encoding" => nil, # no patterns for 8-bit engines
	"exceptions" => false,
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
	"hyphenmin" => [1,2],
	"encoding" => "t8m",
	"exceptions" => false,
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
	"name" => "church slavonic",
	"hyphenmin" => [1, 2],
	"encoding" => nil,
	"exceptions" => true,
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
	"hyphenmin" => [2,2],
	"encoding" => "t2a",
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
	"hyphenmin" => [1, 2],
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
