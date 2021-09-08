--[[
create several empty tables to store functions in
not needed but it makes things look nice
you can load this by just putting "dofile('./phoenix.lua') at the top of your init/main script and putting this file in the same folder"
]]
Phoenix = {
	Math = {},
	Table = {},
	String = {},
	OS = {},
	Version = 1,
}

--[[
create a function and add it to the table
things can be added to a table without rewriting the whole thing
"Phoenix[69] = 420" would create a key with a value of 69 that holds the integer 420
"Phoenix[420] = '69'" would create a key with the value of 420 that holds the string 69
"Phoenix.name = 'idk'" would create a key with the name "name" that holds the string "idk"
to read these simply use "Phoenix[69]", "Phoenix[420]", "Phoenix.name"
you can put a table inside a table
"Phoenix.table = {}" would add an empty table under a key with the name "table"
"Phoenix[7] = {}" would add an empty table under a key with the value of 7
to use these simply use "Phoenix.table" or "Phoenix[7]"
a possible use is "result = Phoenix.key[variable].type[7][20]"
]]

--[[
function for rounding, taken straight from lua manual and changed slightly (lua lacks rounding by default)
"number = Phoenix.Math.Round(number)"
]]
function Phoenix.Math.Round(num)
	return tonumber(string.format("%.0f", num))
end

--[[
function to quickly get the difference between 2 numbers
]]
function Phoenix.Math.Difference(a, b)
	return math.abs(a - b) --just returns an absolute value
end

--[[
function to get the distance between 2 points
"xdist, ydist, dist = Phoenix.Math.Distance(x1, x2, y1, y2)"
if only needind x or y then the opposite value can be anything
]]
function Phoenix.Math.Distance(x1, x2, y1, y2)
	local x3 = math.sqrt((x2 - x1)^2) --calculate x distance
	local y3 = math.sqrt((y2 - y1)^2) --calculate y distance
	return x3, y3, x3 + y3 --combine and return values
end

--[[
function to convert a table to a string
"str = Phoenix.Table.Dump(table)"
]]
function Phoenix.Table.Dump(o) --set names for args used by function, all are local
	if type(o) == 'table' then --i found this on pastebin and i understand how it works but not how to explain it
		local s = '{ '
			for k,v in pairs(o) do
				if type(k) ~= 'number' then
					k = '"' .. k .. '"'
				end
				s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
			end
		return s .. '} '
	else
		return tostring(o)
	end
end

--[[
function to check if a key exists in a table
this does not check tables inside a table unless you manually chose that table
"if (Phoenix.Table.HasKey(Phoenix, 'name') then"
"if (Phoenix.Table.HasKey(Phoenix.table, 69) then"
]]
local function Phoenix.Table.HasKey(tab, val)
	for index, value in ipairs(tab) do --start a loop that incriments through a table
		if value == val then --if target key is found then quit and return true
			return true
		end
	end
	return false --return false if loop finishes
end

--[[
function to load a file or string as a table or execute as code
an ubuntu maintainer called me a cunt for writing this function
"table = Phoenix.Table.Load('table.txt')" loads the first line of table.txt as a table, or executes it if it is not table data
if table.txt does not exist then it will be treated as a string and attempted to be loaded as a table or code
]]
function Phoenix.Table.Load(str)
	local file = io.open(str, 'r')
	if not (file) then --check if file exists
		return assert(load("return " .. str)()) --if not then just load the string and return the result
	end
	local tbl = assert(load("return " .. file:read('*l'))()) --if yes then load the file
	file:close()
	return tbl --return the result after closing the file
end

--[[
function to perform many gsub operations at once
"table = {{'x', 'n',},{'s ', '',},}; str = Phoenix.String.BulkGSUB('texts ', table)" would turn "texts " into "tent"
using ; lets you start a new line without moving to a new line
]]
local function Phoenix.String.BulkGSUB(str, tbl)
	for i=1, #tbl do
		local cleans = tbl[i]
		local str = string.gsub(str, cleans[1], cleans[2]) --replace value 1 with value 2, "str = string.gsub('keyboard water lol', '[abcdefghijklmnpqrstuvxyz]', '')" would turn "keyboard water lol" into "owo"
	end
	return str
end

--[[
function that splits a string into numbered table values using a definable marker
"table = Phoenix.String.Split('I honestly have no idea what im doing, it just works lol', ', ')"
table will become
{
	['1'] = 'I honestly have no idea what im doing',
	['2'] = 'it just works lol',
}
]]
function Phoenix.String.Split(str, splt)
	local tmp = {{splt, "\n"},}
	local str = Phoenix.String.BulkGSUB(str, tmp) --bulk gsub the marker with a linebreak
	for line in str:gmatch("([^\n]*)\n?") do --incriment by line break
	   	table.insert(strlist, line) --add string to a key
	end
	return strlist --return table
end

--[[
function to capture the output of a console command as a string
the raw arg is optional and if set will return unformatted data
"str = Phoenix.OS.Capture('python script.py')"
"number = tonumber(Phoenix.OS.Capture('python script.py')"
you can call a function as a arg in another function
]]
function Phoenix.OS.Capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r')) --popen is a more pog version of open (program open), instead of giving it a file path you give it a console command
	local s = assert(f:read('*a')) --assert() is gay but it prevents a crash if nil is returned
	f:close() --you still need to close because it opens the output of the command as a temporary file
	if raw then --return raw data
		return s
	end
	local tmp = {--create a table for bulk gsub
		{'^%s+', '',},
		{'%s+$', '',},
		{'[\r]+', '',}, --you do not need to end the last value in a table with a comma, i just do
	}
	return Phoenix.String.BulkGSUB(s, tmp) --use bulk gsub to clean up the string then return it
end

--[[
function to halt the program for a specified period of time
"Phoenix.OS.Wait(seconds)"
]]
function Phoenix.OS.Wait(n)
	local t0 = os.clock() --get current system time in seconds
	while os.clock() - t0 <= n do --check if current system time - old system time is less than specified time and loop until no
	end
end

--[[
function to get the number of lines in a file
"number = Phoenix.OS.Lines('textfile.txt')"
]]
function Phoenix.OS.Lines(txt)
	local count = 0 --set number to 0
	for line in io.lines(txt) do --incriment through the file line by line
		count = count + 1 --increase by 1 for every cycle
	end
	return count --return the final value
end

--[[
function to identify what os is running, defaults to linux if it cannot identify (linux and bsd are mostly compatible)
"platform = Phoenix.OS.Platform()"
]]
function Phoenix.OS.Platform()
	local dir = Phoenix.OS.Capture('cd') --run a common command
	local h = "" --init variable to keep it local
	if dir:match('\\') then --if \ is anywhere in result then return windows
		return "Windows"
	else
		dir = Phoenix.OS.Capture("uname -s") --run another common command
		if (dir:match("Darwin")) then --if Darwin is seen 
			return "OSX" --return mac
		else
			local file = io.open('/opt/google/cros-containers/cros-adapta/index.theme', 'r') --check if running under crostini
			if (file ~= nil) then
				file:close()
				return "Chrome" --return chrome os
			end
        end
	end
	return "Linux" --default to linux if nothing is triggered
end