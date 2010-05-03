-- 
--  This is file `luatex-hyphen.lua',
--  generated with the docstrip utility.
-- 
--  The original source files were:
-- 
--  luatex-hyphen.dtx  (with options: `lua')
--  
--  This is a generated file (source: luatex-hyphen.dtx).
--  
--  Copyright (C) 2010 by The LuaLaTeX development team.
--  
--  This work is under the CC0 license.
--  
local error, dofile, pairs, ipairs = error, dofile, pairs, ipairs
local io, texio, lang, kpse = io, texio, lang, kpse
module('luatexhyphen')
local function wlog(msg, ...)
    texio.write_nl('log', 'luatex-hyphen: '..msg:format(...))
end
local function err(msg, ...)
    error('luatex-hyphen: '..msg:format(...), 2)
end
local dbname = "language.dat.lua"
local language_dat
local dbfile = kpse.find_file(dbname)
if not dbfile then
    err("file not found: "..dbname)
else
    language_dat = dofile(dbfile)
end
function lookupname(name)
    if language_dat[name] then
        return language_dat[name], name
    else
        for canon, data in pairs(language_dat) do
            for _,syn in ipairs(data.synonyms) do
                if syn == name then
                    return data, canon
                end
            end
        end
    end
end
function loadlanguage(lname, id)
    local msg = "loading%s patterns and exceptions for: %s (\\language%d)"
    local ldata, cname = lookupname(lname)
    if not ldata then
        err("no entry in %s for this language: %s", dbname, lname)
    end
    if ldata.special then
        if ldata.special == 'null' then
            wlog(msg, ' (null)', cname, id)
            return
        elseif ldata.special:find('^disabled:') then
            err("language disabled by %s: %s (%s)", dbname, cname,
                ldata.special:gsub('^disabled:', ''))
        elseif ldata.special == 0 then
            err("\\language0 should be dumped in the format")
        else
            err("bad entry in %s for language %s")
        end
    end
    wlog(msg, '', cname, id)
    for ext, fun in pairs({pat = lang.patterns, hyp = lang.hyphenation}) do
        local file = 'hyph-'..ldata.code..'.'..ext..'.txt'
        local file = kpse.find_file(file) or err("file not found: %s", file)
        local fh = io.open(file, 'r')
        local data = fh:read('*a') or err("file not readable: %s", f)
        fh:close()
        fun(lang.new(id), data)
    end
end
-- 
--  End of File `luatex-hyphen.lua'.
