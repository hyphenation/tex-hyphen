return {
	["metadata"]={
		["mnemonic"]="mn-lmc",
		["source"]="hyph-mn-cyrl-x-lmc",
	},
	["patterns"]={
		["data"]=io.loaddata(resolvers.findfile("lang-mn-lmc.pat")),
		["minhyphenmin"]=2,
		["minhyphenmax"]=2,
	},
}
