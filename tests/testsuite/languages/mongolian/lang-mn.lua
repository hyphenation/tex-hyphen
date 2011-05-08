return {
	["metadata"]={
		["mnemonic"]="mn",
		["source"]="hyph-mn-cyrl",
	},
	["patterns"]={
		["data"]=io.loaddata(resolvers.findfile("lang-mn.pat")),
		["minhyphenmin"]=2,
		["minhyphenmax"]=2,
	},
}
