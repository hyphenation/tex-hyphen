# -*- coding: utf-8 -*-

class String
	def superstrip
		strip.gsub /%.*$/, ''
	end

	def supersplit
		strip.gsub(/\s+/m,"\n").split("\n")
	end
end

class Author
	def initialize(name,surname,email,contacted1,contacted2)
		@name       = name
		@surname    = surname
		@email      = email
		# this mostly means if email has been recently checked
		@contacted1 = contacted1
		# this means if we made more cooperation with author,
		# exchanging patches etc.
		@contacted2 = contacted2
	end

	attr_reader :name, :surname, :email
end

class Language
	def initialize(language_hash)
		@use_old_patterns = language_hash["use_old_patterns"]
		@use_old_patterns_comment = language_hash["use_old_patterns_comment"]
		@use_old_loader = language_hash["use_old_loader"]
		@filename_old_patterns = language_hash["filename_old_patterns"]
		@filename_old_patterns_other = language_hash["filename_old_patterns_other"]
		@code = language_hash["code"]
		@name = language_hash["name"]
		@synonyms = language_hash["synonyms"]
		@hyphenmin = language_hash["hyphenmin"]
		@encoding = language_hash["encoding"]
		@exceptions = language_hash["exceptions"]
		@message = language_hash["message"]

		@description_s = language_hash["description_s"]
		@description_l = language_hash["description_l"]
		@version       = language_hash["version"]

		@licence = language_hash["licence"]
		@authors = language_hash["authors"]

		if @synonyms==nil then @synonyms = [] end
	end

	def readtexfile(code = @code)
		filename = File.expand_path("../../../../tex/generic/hyph-utf8/patterns/tex/hyph-#{code}.tex", __FILE__);
		lines = IO.readlines(filename, '.').join("")
		lines
	end

	def get_exceptions
		exceptions = readtexfile.superstrip
		unless @exceptions1
			if (exceptions.index('\hyphenation') != nil)
				@exceptions1 = exceptions.gsub(/.*\\hyphenation\s*\{(.*?)\}.*/m,'\1').supersplit
			else
				@exceptions1 = ""
			end
		end

		return @exceptions1
	end

	def get_patterns
		unless @patterns
			if @code == 'eo' then
				@patterns = readtexfile.superstrip.
					gsub(/.*\\patterns\s*\{(.*)\}.*/m,'\1').
					#
					gsub(/\\adj\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e.').
					gsub(/\\nom\{(.*?)\}/m,'\1a. \1aj. \1ajn. \1an. \1e. \1o. \1oj. \1ojn. \1on.').
					gsub(/\\ver\{(.*?)\}/m,'\1as. \1i. \1is. \1os. \1u. \1us.').
					#
					supersplit
			else
				@patterns = readtexfile(if ['nb', 'nn'].include? @code then 'no' else @code end).superstrip.
					gsub(/.*\\patterns\s*\{(.*?)\}.*/m,'\1').
					supersplit
			end
		end

		return @patterns
	end

	def get_comments_and_licence
		@comments_and_licence ||= readtexfile.gsub(/(.*)\\patterns.*/m,'\1')
	end

	# def lc_characters
	# 	if @lc_characters == nil
	# 		lc_characters = Hash.new
	# 		p = self.patterns
	# 		p.each do |pattern|
	# 		end
	# 	end
	# 	return @lc_characters
	# end

	attr_reader :use_old_loader, :use_old_patterns, :use_old_patterns_comment, :filename_old_patterns
	attr_reader :code, :name, :synonyms, :hyphenmin, :encoding, :exceptions, :message
	attr_reader :description_l, :version
	attr_reader :licence, :authors

	def description_s
		@description_s || @message
	end

  def has_quotes
		begin
			get_patterns.any? { |p| p =~ /'/ } && !(['grc', 'el-polyton', 'el-monoton'].include?(@code))
		rescue Errno::ENOENT
		  false
		end
	end

	def has_dashes
		begin
			get_patterns.any? { |p| p =~ /-/ }
		rescue Errno::ENOENT
			false
		end
	end

	# Convenience methods related to TeX Live and the .tlpsrc files
	module TeXLive
		@@path_tex_generic = File.expand_path("../../../../tex/generic", __FILE__)
		@@path_txt = File.join(@@path_tex_generic, 'hyph-utf8', 'patterns', 'txt')

		def loadhyph
			code = @code
			code = @code.gsub 'sh-', 'sr-' if @code =~ /^sh-/
			sprintf 'loadhyph-%s.tex', code
		end

		# ext: 'pat' or 'hyp'
		# filetype: 'patterns' or 'exceptions'
		def plain_text_line(ext, filetype)
			return "" if ['ar', 'fa', 'grc-x-ibycus', 'mn-cyrl-x-lmc'].include? @code

			if @code =~ /^sh-/
				# TODO Warning AR 2018-09-12
				filename = sprintf 'hyph-sh-latn.%s.txt,hyph-sh-cyrl.%s.txt', ext, ext
			else
				filename = sprintf 'hyph-%s.%s.txt', @code, ext
				filepath = File.join(@@path_txt, filename)
				# check for existence of file and that it’s not empty
				unless File.file?(filepath) && File.read(filepath).length > 0
					# if the file we were looking for was a pattern file, something’s wrong
					if ext == 'pat'
						raise sprintf("There is some problem with plain patterns for language [%s]!!!", @code)
					else # the file is simply an exception file and we’re happy
						filename = '' # And we return and empty file name after all
					end
				end
			end

			sprintf "file_%s=%s", filetype, filename
		end

		def exceptions_line
			plain_text_line('hyp', 'exceptions')
		end

		def patterns_line
			plain_text_line('pat', 'patterns')
		end
	end
end

class Authors < Hash
	@@list = []

	def initialize
		authors = {
#authors = {
	"donald_knuth"        => ["Donald", "Knuth", nil, false, false],
	"peter_heslin"        => ["Peter", "Heslin", nil, false, false],
	"dimitrios_filippou"  => ["Dimitrios", "Filippou", "dimitrios{dot}filippou{at}riotinto{dot}com", true, true],
	"claudio_beccari"     => ["Claudio", "Beccari","claudio{dot}beccari{at}gmail{dot}com", true, true],
	"juan_aguirregabiria" => ["Juan M.", "Aguirregabiria", "juanmari{dot}aguirregabiria{at}ehu.es", true, true],
	"igor_marinovic"      => ["Igor", "Marinović", "marinowski{at}gmail.com", true, true],
	"tilla_fick"          => ["Tilla", "Fick", "fick{dot}tilla{at}gmail{dot}com", true, true],
	"chris_swanepoel"     => ["Chris", "Swanepoel", "cj{at}swanepoel{dot}net", true, true],
	"matjaz_vrecko"       => ["Matjaž", "Vrečko", "matjaz{at}mg-soft{dot}si", true, true],
	"goncal_badenes"      => ["Gonçal", "Badenes", "g{dot}badenes{at}ieee.org", false, false],
	"pavel_sevecek"       => ["Pavel", "Ševeček", "pavel{at}lingea{dot}cz", false, false],
	# email doesn't work
	"jana_chlebikova"     => ["Jana", "Chlebíková", "chlebikj{at}dcs{dot}fmph{dot}uniba{dot}sk", false, false],
	"yannis_haralambous"  => ["Yannis", "Haralambous", "yannis{dot}haralambous{at}telecom-bretagne{dot}eu", true, false],
	"frank_jensen"        => ["Frank", "Jensen", "frank{dot}jensen{at}hugin{dot}com", true, true],
	"sergei_pokrovsky"    => ["Sergei", "Pokrovsky", "sergio{dot}pokrovskij{at}gmail{dot}com", true, true],
	"javier_bezos"        => ["Javier", "Bezos", "jbezos{at}tex-tipografia{dot}com", true, true],
	"een_saar"            => ["Enn", "Saar", "saar{at}aai{dot}ee", false, false],
	"dejan_muhamedagic"   => ["Dejan", "Muhamedagić", "dejan{at}hello-penguin{dot}com", true, true],
	"brian_wilson"        => ["Brian", "Wilson", "bountonw{at}gmail{dot}com", true, true],
	"arthur_reutenauer"   => ["Arthur", "Reutenauer", "arthur{dot}reutenauer{at}normalesup{dot}org", true, true],
	"mojca_miklavec"      => ["Mojca", "Miklavec", "mojca{dot}miklavec{dot}lists{at}gmail{dot}com", true, true],
	"santhosh_thottingal" => ["Santhosh", "Thottingal", "santhosh{dot}thottingal{at}gmail{dot}com>", true, true],
	# email doesn't work
	"yves_codet"          => ["Yves", "Codet", "ycodet{at}club-internet{dot}fr", true, true],
	"rune_kleveland"      => ["Rune", "Kleveland", nil, false, false],
	# email doesn't work
	"ole_michael_selberg" => ["Ole Michael", "Selberg", "o{dot}m{dot}selberg{at}c2i{dot}net", true, true],
	"dorjgotov_batmunkh"  => ["Dorjgotov", "Batmunkh", "bataak{at}gmail{dot}com", true, true],
	"nazar_annagurban"    => ["Nazar", "Annagurban", "nazartm{at}gmail{dot}com", false, false],
	"jan_michael_rynning" => ["Jan Michael", "Rynning", nil, false, false],
	"eduard_werner"       => ["Eduard", "Werner", "edi{dot}werner{at}gmx{dot}de", false, false],
	"werner_lemberg"      => ["Werner", "Lemberg", "wl{at}gnu{dot}org", true, true],
	# email doesn't work
	"pedro_j_de_rezende"  => ["Pedro J.", "de Rezende", "rezende{at}ddc{dot}unicamp{dot}br", false, false],
	"j_joao_dias_almeida" => ["J. Joao", "Dias Almeida", "jj{at}di{dot}uminho{dot}pt"],
	# email doesn't work
	"piet_tutelaers"      => ["Piet", "Tutelaers", "p{dot}t{dot}h{dot}tutelaers{at}tue{dot}nl", false, false],
	"vytas_statulevicius" => ["Vytas", "Statulevičius", "vytas{at}vtex{dot}nl", false, false],
	"sigitas_tolusis"     => ["Sigitas", "Tolušis", "sigitas{at}vtex{dot}lt", false, false],
	"janis_vilims"        => ["Janis", "Vilims", "jvilims{at}apollo{dot}lv", false, false],
	"joerg_knappen"       => ["Jörg", "Knappen", "jknappen{at}web{dot}de", true, true],
	"medeni_shemde"        => ["Medeni", "Shemdê", nil, false, false],
	"terry_mart"          => ["Terry", "Mart", "mart{at}kph{dot}uni-mainz{dot}de", false, false],
	# email doesn't work
	"jorgen_pind"         => ["Jorgen", "Pind", "jorgen{at}lexis{dot}hi{dot}is", false, false],
	"marteinn_sverrisson" => ["Marteinn", "Sverrisson", nil, false, false],
	# email doesn't work
	"kristinn_gylfason"   => ["Kristinn", "Gylfason", "kristgy{at}ieee{dot}org", false, false],
	# email doesn't work
	"kevin_p_scannell"    => ["Kevin P.", "Scannell", "scanell{at}slu{dot}edu", false, false],
	# email doesn't work
	"peter_kleiweg"       => ["Peter", "Kleiweg", "p{dot}c{dot}c{dot}kleiweg{at}rug{dot}nl", false, false],
	"hanna_kolodziejska"  => ["Hanna", "Kołodziejska", nil, false, false],
	"boguslaw_jackowski"  => ["Bogusław", "Jackowski", nil, true, true],
	"marek_rycko"         => ["Marek", "Ryćko", nil, false, false],
	"vladimir_volovich"   => ["Vladimir", "Volovich", nil, true, true], # TODO add e-mail address
	"alexander_i_lebedev" => ["Alexander I.", "Lebedev", "swan{at}scon155{dot}phys{dot}msu{dot}su", false, false], # Not sure were 'I' belongs
	# first email doesn't work
	"maksym_polyakov"     => ["Maksym", "Polyakov", "polyama{at}auburn{dot}edu", false, false], # Second e-mail address in ukrhypmp.tex: mpoliak@i.com.ua
	"adrian_rezus"        => ["Adrian", "Rezus", "adriaan{at}\{sci,cs\}{dot}kun{dot}nl", false, false],
	# email doesn't work
	"sahak_petrosyan"     => ["Sahak", "Petrosyan", "sahak{at}mit{dot}edu", true, true], # I think "true, true" is right.  Arthur
	"dominik_wujastyk"    => ["Dominik", "Wujastyk", "wujastyk{at}gmail{dot}com", false, false],
	"graham_toal"         => ["Graham", "Toal", nil, false, false],
	"donald_e_knuth"      => ["Donald E.", "Knuth", nil, false, false], # Don doesn't use e-mail ;-)
	"gerard_d_c_kuiken"   => ["Gerard D.C.", "Kuiken", nil, false, false],
	"pierre_mackay"       => ["P. A.", "MacKay", nil, true, true],
	"h_turgut_uyar"       => ["H. Turgut", "Uyar", "uyar{at}itu{dot}edu{tr}", true, true],
	# email doesn't work
	"s_ekin_kocabas"      => ["S. Ekin", "Kocabas", "kocabas{at}stanford{dot}edu", true, true],
	"bence_nagy"          => ["Bence", "Nagy", "nagybence{at}tipogral{dot}hu", true, true],
	"kauko_saarinen"      => ["Kauko", "Saarinen", nil, false, false],
	"fred_karlsson"       => ["Fred", "Karlsson", nil, false, false],
	"rene_bastian"        => ["René", "Bastian", nil, false, false], # TODO make contact
	"daniel_flipo"        => ["Daniel", "Flipo", nil, false, false], # TODO make contact
	"bernard_gaulle"      => ["Bernard", "Gaulle", nil, false, false], # Deceased...
	"theppitak_karoonboonyanan" => ["Theppitak", "Karoonboonyanan", "theppitak{at}gmail{dot}com", true, true],
	"levan_shoshiashvili" => ["Levan", "Shoshiashvili", "shoshia{at}hotmail{dot}com", true, true],
	# email doesn't work
	"javier_mugica"       => ["Javier", "Múgica", "javier{at}digi21{dot}eu", true, true],
	"georgi_boshnakov"    => ["Georgi", "Boshnakov", "georgi{dot}boshnakov{at}manchester{dot}ac{dot}uk", true, true],
	"mike_kroutikov"      => ["Mike", "Kroutikov", "pgmmpk{at}gmail{dot}com", true, true],
	"aleksandr_andreev"   => ["Aleksandr", "Andreev", "", true, true],
	"maksim_salau"        => ["Maksim", "Salau", "maksim{dot}salau{at}gmail{dot}com", true, false],
	"wie_ming_ang"        => ["Wie-Ming", "Cittānurakkho Bhikkhu", "wiemingang{at}gmail{dot}com", true, true]
}
#
		authors.each do |a|
			author = Author.new(a[1][0], a[1][1], a[1][2], a[1][3], a[1][4])
			@@list.push(author)
			self[a[0]] = author
		end
	end
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

class Language
	@@list = nil
	def self.all
		return @@list if @@list

		require_relative 'language-data'
		@@list = @@languages.map do |language_data|
			new language_data
		end
	end

	module TeXLive
		@@collection_mapping = {
			"en-gb"=>"english",
			"en-us"=>"english",
			"nb"=>"norwegian",
			"nn"=>"norwegian",
			"de-1901"=>"german",
			"de-1996"=>"german",
			"de-ch-1901"=>"german",
			"mn-cyrl"=>"mongolian",
			"mn-cyrl-x-lmc"=>"mongolian",
			"el-monoton"=>"greek",
			"el-polyton"=>"greek",
			"grc"=>"ancientgreek",
			"grc-x-ibycus"=>"ancientgreek",
			"zh-latn-pinyin"=>"chinese",
			"as"=>"indic",
			"bn"=>"indic",
			"gu"=>"indic",
			"hi"=>"indic",
			"kn"=>"indic",
			"ml"=>"indic",
			"mr"=>"indic",
			"or"=>"indic",
			"pa"=>"indic",
			"ta"=>"indic",
			"te"=>"indic",
			"sh-latn"=>"serbian",
			"sh-cyrl"=>"serbian",
			"la"=>"latin",
			"la-x-classic"=>"latin",
			"la-x-liturgic"=>"latin"
		}

		def make_mappings
			# The reverse of @@collection_mapping above: a hash with collection names as key,
			# and an array of the names of languages it contains
			@@language_collections = Hash.new
			@@collection_mapping.each do |bcp47, collection|
				(@@language_collections[collection] ||= []) << bcp47
			end

			# a hash with the names of TeX Live packages, either individual language names,
			# or an array of languages as the value
			@@packages = Hash.new
			all.each do |language|
				if groupname = @@collection_mapping[language.code]
					# language is part of a collection
					(@@packages[groupname] ||= []) << language
				else
					# language is individual, but yields to collection if there is one with the same name
					@@packages[language.name] = [language] unless @@language_collections[language.name]
				end
			end
		end

		@@packages = nil
		def packages
			make_mappings unless @@packages
			@@packages
		end
	end

	def <=>(other)
	  self.code <=> other.code
	end
end
