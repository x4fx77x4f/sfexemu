guestEnv.assert = assert
guestEnv.class = class
guestEnv.Color = function(r, g, b, a)
	return types.Color:new(r, g, b, a)
end
guestEnv.debugGetInfo = debug.getinfo
guestEnv.debugGetLocal = function(...)
	local name = debug.getlocal(...)
	return name
end
guestEnv.dofile = function(path, ...)
	local func = assert(curchip.includes[path], "Can't find file '"..path.."' (did you forget to \x2d-@include it?)")
	debug.setupvalue(func, 1, curchip.env)
	return func(...)
end
guestEnv.entity = function(index)
	return entities[index] or types.Entity:new({
		valid = false
	})
end
guestEnv.error = error
--[[ BROKEN
guestEnv.getfenv = function()
	return debug.getupvalue(function() end, 1)
end
--]]
guestEnv.getmetatable = getmetatable
guestEnv.ipairs = ipairs
guestEnv.isValid = function(v)
	return v.isValid and v:isValid()
end
guestEnv.loadstring = loadstring
guestEnv.next = next
guestEnv.owner = function()
	return curchip.owner
end
guestEnv.pairs = pairs
guestEnv.pcall = pcall
guestEnv.player = function()
	return curchip.player
end
guestEnv.print = function(...)
	print("[GUEST]", ...)
end
guestEnv.quotaAverage = function()
	return curchip:movingCPUAverage()
end
guestEnv.quotaMax = function()
	return curchip.cpuQuota
end
guestEnv.quotaUsed = function()
	return curchip.cpu_total
end
guestEnv.rawget = rawget
guestEnv.rawset = rawset
guestEnv.require = guestEnv.dofile
guestEnv.requiredir = guestEnv.dodir
guestEnv.select = select
--[[ BROKEN
guestEnv.setfenv = function(func, env)
	assert(type(func) == "function", "Main Thread is protected!")
	debug.setupvalue(func, 1, env)
end
--]]
guestEnv.setmetatable = setmetatable
guestEnv.throw = error
guestEnv.tonumber = tonumber
guestEnv.tostring = tostring
guestEnv.type = type
guestEnv.unpack = table.unpack
guestEnv.version = function()
	return "StarfallEx"
end
guestEnv.xpcall = xpcall
