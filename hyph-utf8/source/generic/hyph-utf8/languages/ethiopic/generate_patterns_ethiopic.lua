--[[
	Languages: Amharic (am) & Others
	
	http://books.google.com/books?id=r87yh5z66TEC

	http://www.omniglot.com/writing/ethiopic.htm
	http://www.omniglot.com/writing/amharic.htm

	http://www.ancientscripts.com/ethiopic.html
--]]


loadfile ("etiopic_syllables.lua")()

--print(table.serialize(f))
print(table.serialize(syllables))

for _,consonant in pairs(syllables) do
	for _,syllable in pairs(consonant) do
		--print(syllable)
	end
end
