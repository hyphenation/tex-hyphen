#!/usr/bin/env texlua

-- Extract Ethiopic syllables from the Unicode Character Database.
-- Copyright (c) 2011, 2016 Arthur Reutenauer
-- http://www.hyphenation.org/
-- === Text of the MIT licence ===
-- This file is available under the terms of the MIT licence.
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the “Software”), to deal
-- in the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- === End of MIT licence ===
-- Version 0.2 2016-05-22

-- Use with TeXLua.

local function extract_mit_licence()
  reading_mit_licence = false
  bolicence = lpeg.P'=== Text of the MIT licence ==='
  eolicence = lpeg.P'=== End of MIT licence ==='
  mit_licence = { }
  for line in io.lines(arg[0]) do
    line = line:gsub('^%-%- ', ''):gsub('^%-%-', '')
    if eolicence:match(line) then
      reading_mit_licence = false
    end

    if reading_mit_licence then
      mit_licence[#mit_licence + 1] = line
    end

    if bolicence:match(line) then
      reading_mit_licence = true
    end
  end
end

-- Small library to convert a hexadecimal string to a number
local function hex_digit_to_num(h)
  local c = string.byte(h)
  if c >= 48 and c < 58
  then return c - 48
  elseif c >= 65 and c < 71
  then return c - 55
  elseif c >= 97 and c < 103
  then return c - 87
  end
  return 0
end

local function hex_string_to_num(hex)
  local n = 0
  for i = 1, string.len(hex) do
    n = 16 * n + hex_digit_to_num(string.sub(hex, i, i + 1))
  end
  return n
end

local ucd_file = "UnicodeData.txt"

local error_install_ucd = [[
Error: the Unicode Character Database could not be found.
Please download it from http://www.unicode.org/Public/UNIDATA/UnicodeData.txt
and install it in the current directory.]]

if not lfs.attributes(ucd_file) then
  print(error_install_ucd)
  return -1
end

local P, R, C, match = lpeg.P, lpeg.R, lpeg.C, lpeg.match

local digit = R"09" + R"AF"
local colon = P";"
local field = (1 - colon)^0
local eth_syll = P"ETHIOPIC SYLLABLE " * C(field)
local ucd_entry = C(digit^4) * colon * eth_syll

local pattfile = assert(io.open("../../../../../tex/generic/hyph-utf8/patterns/tex/hyph-mul-ethi.tex", "w"))


extract_mit_licence()

pattfile:write[[
% title: Experimental pattern file for languages written using the Ethiopic script.
% copyright: Copyright (c) 2011, 2016 Arthur Reutenauer
% notice: This file is part of the hyph-utf8 package.
%     See http://www.hyphenation.org for more information
% language:
%     name: Multiple languages using the Ethiopic scripts
%     tag: mul-ethi
% version: 0.2 2016-05-22
% licence:
%     - name: MIT
%     - url: https://opensource.org/licenses/MIT
%     - text: >
]]

for _, line in ipairs(mit_licence) do
  if lpeg.match(lpeg.P(-1), line) then
    pattfile:write('%\n')
  else
    pattfile:write('%         ', line, '\n')
  end
end

pattfile:write[[
% ==========================================
% This is a generated file.  If you wish to edit it, consider adapting the
% generating programme
% (https://github.com/hyphenation/tex-hyphen/blob/master/hyph-utf8/source/generic/hyph-utf8/languages/mul-ethi/generate_patterns_mul-ethi.lua).
%
% The BCP 47 language tag for that file is “mul-ethi” to reflect the fact that
% it can be used by multiple languages (and a single script, Ethiopic).  It is,
% though, not supposed to be linguistically relevant and should, for proper
% typography, be replaced by files tailored to individual languages.  What we
% do for the moment is to simply allow break on either sides of Ethiopic
% syllables, and to forbid it before some punctuation marks particular to
% the Ethiopic script (which we thus make letters for this purpose).
%
]]

pattfile:write"\\patterns{%\n"
for ucd_line in io.lines(ucd_file) do
  local usv, char_name = match(ucd_entry, ucd_line)
  -- print(string.format("%04X", usv))
  -- if usv then print(usv, char_name) end
  if usv then
    local hex = hex_string_to_num(usv)
    local hex = hex_string_to_num
    pattfile:write("1", unicode.utf8.char(hex_string_to_num(usv)), "1 ")
    pattfile:write("% U+", usv, " ", char_name:lower(), "\n")
  end
end

pattfile:write("2", unicode.utf8.char(0x1361), "1 % U+1361 ETHIOPIC WORDSPACE\n")
pattfile:write("2", unicode.utf8.char(0x1362), "1 % U+1362 ETHIOPIC FULL STOP\n")

pattfile:write"}"

assert(io.close(pattfile))
