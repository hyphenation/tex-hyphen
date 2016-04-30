print "****************************"

return {
	["metadata"]={
		["mnemonic"]="ka",
		["source"]="hyph-ka",
	},
	["patterns"]={
		["data"]=io.loaddata(resolvers.findfile("lang-ka.pat")),
		["minhyphenmin"]=2,
		["minhyphenmax"]=2,
	},
	["version"]="0.1",
}
