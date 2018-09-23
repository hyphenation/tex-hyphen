module TeX
module Hyphen
class Author
	@@author_data = {
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
end
end
end
