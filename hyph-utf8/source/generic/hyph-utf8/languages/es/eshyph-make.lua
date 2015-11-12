-- (encoding:utf-8)

-- GUIONIZADO DE PALABRAS
-- ~~~~~~~~~~~~~~~~~~~~~
-- v 4.7
--
-- License: MIT/X11
--
-- Copyright (c) 1993, 1997 Javier Bezos
-- Copyright (c) 2001-2015 Javier Bezos and CervanTeX
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- For further info, bug reports and comments:
--
--       http://www.tex-tipografia.com/spanish_hyphen.html

----------

-- ethymologic, trailing no, bad words, prefixes, consonant + h, tl

patfile = io.open('eshyph.tex', 'w')
patfile:write('\\patterns{\n')

-- Basic patters
-- Using the characters iterator in luatex

digraphs = 'ch ll'
liquids =  'bl cl fl gl kl pl vl br cr dr fr gr kr pr rr tr vr'
avoid = 'tl ts tx tz'
silent = 'h'
chrl = 'chr chl'
letters = 'bcdfghjklmnpqrstvwxyz'

for n in letters:gmatch('.') do
  if silent:find(n) then
    patfile:write('   4' .. n .. '.')
  else
    patfile:write('1' .. n .. ' 4' .. n .. '. .' .. n .. '2')
  end
  for m in letters:gmatch('.')  do
    pat = n .. m
    if digraphs:find(pat) then
      patfile:write('    ')
    elseif liquids:find(pat) then
      patfile:write('    ')
    elseif avoid:find(pat) then
      patfile:write('    ')
    elseif silent:find(m) then
	  patfile:write(' 2' .. n .. '1' .. m)
    else
      patfile:write(' 2' .. pat)
    end
  end
  patfile:write('\n')
end

patfile:write('1ñ 4ñ.\n')

for n in digraphs:gmatch('%S+') do
  patfile:write(n:sub(1,1) .. '4' .. n:sub(2,2) .. ' 4' .. n .. '.')
  for m in letters:gmatch('.') do
    pat = n .. m
    if chrl:find(pat) then
      patfile:write(' ' .. n .. '2' .. m)
    else
      patfile:write(' 2' .. pat)
    end
  end
  patfile:write('\n')
end

for n in liquids:gmatch('%S+') do
  patfile:write(n:sub(1,1) .. '2' .. n:sub(2,2) .. ' 4' .. n .. '.')
  for m in letters:gmatch('.') do
    patfile:write(' 2' .. n .. '2' .. m)
  end
  patfile:write('\n')
end

letters = 'bcdlmnrstxy'
etim = 'pt ct cn ps mn gn ft pn cz tz ts'

for n in etim:gmatch('%S+') do
  for m in letters:gmatch('.') do
    patfile:write('2' .. m .. '3' .. n:sub(1,1) .. '2' .. n:sub(2,2) .. ' ')
  end
  patfile:write('4' .. n .. '.\n')
end

src = io.open('eshyph.src')

function prefix(p)
  if p:match('r$') then
    p = p:sub(1,-2) .. '2' .. p:sub(-1) .. '1'
    patfile:write(p:sub(1,-2) .. '3r\n')
  elseif p:match('[aeiou]$') then
    p = p .. '1'
    patfile:write(p .. 'h\n')
  end 
  patfile:write(p .. 'a2 ' .. p .. 'e2 ' .. p .. 'i2 ' .. p .. 'o2 ' .. p .. 'u2\n')
  patfile:write(p .. 'á2 ' .. p .. 'é2 ' .. p .. 'í2 ' .. p .. 'ó2 ' .. p .. 'ú2\n')

end

for ln in src:lines() do
  ln = ln:match('[^%%]*')
  for p in ln:gmatch('%S+') do
    if p:match('/(.*)/') then
      prefix(p:match('/(.*)/'))
    elseif p:sub(1,1) == '*' then
      patfile:write('de2s3' .. p:sub(2) .. '\n')
    else
      patfile:write(p .. '\n')
    end
  end
end

patfile:write('}')
patfile:close()
