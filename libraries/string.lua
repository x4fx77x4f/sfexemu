local function formattedTime(seconds, format)
	seconds = seconds or 0
	local hours = math.floor(seconds/3600)
	local minutes = math.floor((seconds/60)%60)
	local milliseconds = (seconds-math.floor(seconds))*100
	seconds = math.floor(seconds%60)
	if format then
		return string.format(format, minutes, seconds, milliseconds)
	else
		return {
			h = hours,
			m = minutes,
			s = seconds,
			ms = millisecs
		}
	end
end
local function patternSafe(str)
	return string.gsub(str, ".", {
		["("] = "%(",
		[")"] = "%)",
		["."] = "%.",
		["%"] = "%%",
		["+"] = "%+",
		["-"] = "%-",
		["*"] = "%*",
		["?"] = "%?",
		["["] = "%[",
		["]"] = "%]",
		["^"] = "%^",
		["$"] = "%$",
		["\x00"] = "%z"
	})
end
local function round(n, idp)
	local mult = 10^(idp or 0)
	return math.floor(n*mult+0.5)/mult
end
local function explode(separator, str, withpattern)
	if separator == "" then
		local ret = {}
		for i=1, string.len(str) do
			ret[i] = string.sub(str, i, i)
		end
		return ret
	end
	local ret = {}
	local current_pos = 1
	for i=1, string.len(str) do
		local start_pos, end_pos = string.find(str, separator, current_pos, not withpattern)
		if not start_pos then
			break
		end
		ret[i] = string.sub(str, current_pos, start_pos-1)
		current_pos = end_pos+1
	end
	table.insert(ret, string.sub(str, current_pos))
	return ret
end
guestEnv.string = {
	byte = string.byte,
	char = string.char,
	comma = function(n)
		if type(n) == "number" then
			n = string.format("%f", n)
			n = string.match(n, "^(.-)%.?0*$")
		end
		local k
		while true do
			n, k = string.gsub(n, "^(-?%d+)(%d%d%d)", "%1,%2")
			if k == 0 then
				break
			end
		end
		return n
	end,
	dump = string.dump,
	endsWith = function(s, k)
		return k == "" or string.sub(s, -string.len(k)) == k
	end,
	explode = explode,
	find = string.find,
	format = string.format,
	formattedTime = formattedTime,
	fromColor = function(color)
		return string.format("%i %i %i %i", color.r, color.g, color.b, color.a)
	end,
	getChar = function(s, i)
		return string.sub(s, i, i)
	end,
	getExtensionFromFilename = function(path)
		return string.match(path, "%.([^%.]+)$")
	end,
	getFileFromFilename = function(path)
		if not string.find(path, "\\") and not string.find(path, "/") then
			return path
		end
		return string.match(path, "[\\/]([^\\/]+)$") or ""
	end,
	getPathFromFilename = function(path)
		return string.match(path, "^(.*[\\/])[^\\/]-$") or ""
	end,
	gmatch = string.gmatch,
	gsub = string.gsub,
	implode = function(separator, tbl)
		return table.concat(tbl, separator)
	end,
	javascriptSafe = function(str)
		str = string.gsub(".", {
			["\\"] = "\\\\",
			["\x00"] = "\\x00",
			["\b"] = "\\b",
			["\t"] = "\\t",
			["\n"] = "\\n",
			["\v"] = "\\v",
			["\f"] = "\\f",
			["\r"] = "\\r",
			['"'] = '\\"',
			["'"] = "\\'"
		})
		str = string.gsub("\xe2\x80\xa8", "\\xe2\\x80\\xa8") -- U+2028
		str = string.gsub("\xe2\x80\xa9", "\\xe2\\x80\\xa9") -- U+2029
		return str
	end,
	left = function(str, n)
		return string.sub(str, 1, n)
	end,
	len = string.len,
	lower = string.lower,
	match = string.match,
	niceSize = function(size)
		size = tonumber(size)
		if size <= 0 then
			return "0"
		elseif size < 1000 then
			return size.." Bytes"
		elseif size < 1000*1000 then
			return round(size/1000, 2).." KB"
		elseif size < 1000*1000*1000 then
			return round(size/(1000*1000), 2).." MB"
		else
			return round(size/(1000*1000*1000), 2).." GB"
		end
	end,
	niceTime = function(seconds)
		if not seconds then
			return "a few seconds"
		elseif seconds < 60 then
			local t = math.floor(seconds)
			return t.." second"..(t == 1 and "s" or "")
		elseif seconds < 60*60 then
			local t = math.floor(seconds/60)
			return t.." minute"..(t == 1 and "s" or "")
		elseif seconds < 60*60*24 then
			local t = math.floor(seconds/(60*60))
			return t.." hour"..(t == 1 and "s" or "")
		elseif seconds < 60*60*24*7 then
			local t = math.floor(seconds/(60*60*24))
			return t.." week"..(t == 1 and "s" or 0)
		elseif seconds < 60*60*24*365 then
			local t = math.floor(seconds/(60*60*24*7))
			return t.." week"..(t == 1 and "s" or "")
		else
			local t = math.floor(seconds/(60*60*24*365))
			return t.." year"..(t == 1 and "s" or "")
		end
	end,
	normalizePath = string.normalizePath,
	patternSafe = patternSafe,
	replace = function(str, tofind, toreplace)
		local tbl = explode(tofind, str)
		return tbl[1] and table.concat(tbl, toreplace) or str
	end,
	rep = string.rep,
	reverse = string.reverse,
	right = function(str, n)
		return string.sub(str, -n)
	end,
	setChar = function(s, k, v)
		return string.sub(s, 0, k-1)..v..string.sub(s, k+1)
	end,
	split = function(str, delimiter)
		return explode(delimiter, str)
	end,
	startWith = function(str, k)
		return string.sub(str, 1, string.len(k)) == k
	end,
	stripExtension = function(path)
		local i = string.match(path, ".+()%.%w+$")
		return i and string.sub(1, i-1) or path
	end,
	sub = string.sub,
	toColor = function(str)
		local r, g, b, a = string.match(str, "(%d+) (%d+) (%d+) (%d+)")
		return types.Color:new(tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255, tonumber(a) or 255)
	end,
	toMinutesSeconds = function(seconds)
		return formattedTime(seconds, "%02i:%02i")
	end,
	toMinutesSecondsMilliseconds = function(seconds)
		return formattedTime(seconds, "%02i:%02i:%02i")
	end,
	toTable = function(str)
		local tbl = {}
		for i=1, string.len(str) do
			tbl[i] = string.sub(str, i, i)
		end
		return tbl
	end,
	trim = function(s, c)
		c = c and patternSafe(c) or "%s"
		return string.match(s, "^"..c.."*(.-)"..c.."*$") or s
	end,
	trimLeft = function(s, c)
		c = c and patternSafe(c) or "%s"
		return string.match(s, "^"..c.."*(.+)$") or s
	end,
	trimRight = function(s, c)
		c = c and patternSafe(c) or "%s"
		return string.match(s, "^(.-)"..c.."*$") or s
	end,
	upper = string.upper
}
