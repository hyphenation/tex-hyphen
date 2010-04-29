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

luatexhyphen = {}

luatexhyphen.version = "1.3beta"

local dbname = "language.dat.lua"

local function warn (msg, ...)
    texio.write_nl('luatex-hypen: '..string.format(msg, ...))
end

luatexhyphen.language_dat = {}
local dbfile = kpse.find_file(dbname)
if not dbfile then
    warn("file not found: "..dbname)
else
    luatexhyphen.language_dat = dofile(dbfile)
end

local function lookupname(l)
    if luatexhyphen.language_dat[l] then
        return luatexhyphen.language_dat[l], l
    else
        for orig,lt in pairs(luatexhyphen.language_dat) do
            for _,syn in ipairs(lt.synonyms) do
                if syn == l then
                    return lt, orig
                end
            end
        end
    end
    return nil
end

function luatexhyphen.loadpatterns(l, id)
    local lt, orig = lookupname(l)
    if not lt or not lt.code then
        warn("no entry in %s for this language: %s", dbname, l)
        return
    end
    local n = 'hyph-'..lt.code..'.pat.txt'
    local f = kpse.find_file(n)
    if not f then
        warn("file not found: %s", n)
        return
    end
    f = io.open(f, 'r')
    local data = f:read('*a')
    f:close()
    if not data then
        warn("file not readable: %s", f)
        return
    end
    local lobj = lang.new(id)
    warn("loading patterns for: %s", orig)
    lang.patterns(lobj, data)
end

function luatexhyphen.loadexceptions(l, id)
    local lt, orig = lookupname(l)
    if not lt or not lt.code then
        warn("no entry in %s for this language: %s", dbname, l)
        return
    end
    local n = 'hyph-'..lt.code..'.hyp.txt'
    local f = kpse.find_file(n)
    if not f then
        warn("file not found: %s", n)
        return
    end
    f = io.open(f, 'r')
    local data = f:read('*a')
    f:close()
    if not data then
        warn("file not readable: %s", f)
        return
    end
    local lobj = lang.new(id)
    warn("loading exceptions for: %s", orig)
    lang.hyphenation(lobj, data)
end

-- 
--  End of File `luatex-hyphen.lua'.
