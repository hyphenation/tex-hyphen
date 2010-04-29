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

local function warn (msg, ...)
    texio.write_nl('luatex-hypen: '..string.format(msg, ...))
end

luatexhyphen.languagesdat = {}

local languagesdatfile = kpse.find_file("languages.dat.lua")
if not languagesdatfile then
    warn("file not found: languages.dat.lua")
else
    luatexhyphen.languagesdat = dofile(languagesdatfile)
end

local function lookupname(l)
    if luatexhyphen.languagesdat[l] then
        return luatexhyphen.languagesdat[l], l
    else
        for orig,lt in pairs(luatexhyphen.languagesdat) do
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
        warn("no entry in languages.dat.lua for this language: %s", l)
        return
    end
    local f = kpse.find_file(lt.code .. '.pat.txt')
    if not f then
        warn("file not found: %s", lt.code .. '.pat.txt')
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
        warn("no entry in languages.dat.lua for this language: %s", l)
        return
    end
    local f = kpse.find_file(lt.code .. '.hyp.txt')
    if not f then
        warn("file not found: %s", lt.code .. '.pat.txt')
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
