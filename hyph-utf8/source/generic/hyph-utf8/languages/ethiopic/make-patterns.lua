-- Extract Ethiopic syllables from the Unicode Character Database.
-- Arthur Reutenauer, London, 2011-01-09, for the hyph-utf8 project
-- http://tug.org/tex-hyphen
-- Copyright TeX Users Group, 2011.
-- You can freely use, modify and / or redistribute this file.

-- Use with TeXLua.

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
Please download it, etc.]] -- TODO

if not lfs.attributes(ucd_file) then
  print(error_install_ucd)
  return -1
end

local P, R, C, match = lpeg.P, lpeg.R, lpeg.C, lpeg.match

local digit = R"09" + R"AF"
local colon = P";"
local field = (1 - colon)^0
local eth_syll = P"ETHIOPIC SYLLABLE" * field
local ucd_entry = C(digit^4) * colon * C(eth_syll)

local pattfile = assert(io.open("hyph-mul-ethi.tex", "w"))

pattfile:write"\\patterns{%\n"
for ucd_line in io.lines(ucd_file) do
  local usv, char_name = match(ucd_entry, ucd_line)
  -- print(string.format("%04X", usv))
  -- if usv then print(usv, char_name) end
  if usv then
    -- arbitrarily excluding Ethiopic Extended-A
    -- because they're not in unicode-letters.tex
    local hex = hex_string_to_num(usv)
    if hex < 0xAB00  then
      local hex = hex_string_to_num
      pattfile:write("1", unicode.utf8.char(hex_string_to_num(usv)), "1 ")
      pattfile:write("% U+", usv, " ", char_name, "\n")
    end
  end
end

pattfile:write("2", unicode.utf8.char(0x1361), "1 % U+1361 ETHIOPIC WORDSPACE\n")

pattfile:write"}"

assert(io.close(pattfile))
