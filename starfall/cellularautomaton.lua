--@name Cellular automaton
--@author x4fx77x4f
--@client
local grid = {}
local grid2 = {}
local rulename = "Conway's Game of Life"
local w, h = 256, 256
local xm, ym = 1024/w, 1024/h
local threshold = quotaMax()*0.25
local function yield(rt)
	if math.max(quotaUsed(), quotaAverage()) >= threshold then
		coroutine.yield()
		if rt then
			render.selectRenderTarget(rt)
		end
	end
end
local function stdseed(x, y)
	return math.random(1, 4) == 1
end
local function stddraw(state, x, y)
	if state then
		render.setRGBA(255, 255, 255, 255)
		render.drawRect((x-1)*xm, (y-1)*ym, xm, ym)
	end
end
local function stdsave(handle)
	handle:write("SFCA "..rulename.."\n")
	handle:writeShort(w+32767)
	handle:writeShort(h+32767)
	for y=1, h do
		local row = grid[y]
		for x=1, w, 8 do
			local b = 0
			b = rawget(row[x]) and bit.bor(b, 128) or b
			b = rawget(row[x+1]) and bit.bor(b, 64) or b
			b = rawget(row[x+2]) and bit.bor(b, 32) or b
			b = rawget(row[x+3]) and bit.bor(b, 16) or b
			b = rawget(row[x+4]) and bit.bor(b, 8) or b
			b = rawget(row[x+5]) and bit.bor(b, 4) or b
			b = rawget(row[x+6]) and bit.bor(b, 2) or b
			b = rawget(row[x+7]) and bit.bor(b, 1) or b
			handle:writeByte(b)
			yield()
		end
	end
	handle:close()
end
local rules
local function stdload(handle)
	assert(handle:read(5) == "SFCA ", "invalid header")
	assert(handle:readLine() == rulename, "incorrect rule")
end
rules = {
	["Conway's Game of Life"] = {stdseed, function(x, y)
		local live = grid[y][x]
		local neighbors = 0
		if grid[y-1][x] then neighbors = neighbors+1 end
		if grid[y-1][x+1] then neighbors = neighbors+1 end
		if grid[y][x+1] then neighbors = neighbors+1 end
		if grid[y+1][x+1] then neighbors = neighbors+1 end
		if grid[y+1][x] then neighbors = neighbors+1 end
		if grid[y+1][x-1] then neighbors = neighbors+1 end
		if grid[y][x-1] then neighbors = neighbors+1 end
		if grid[y-1][x-1] then neighbors = neighbors+1 end
		if live then
			return neighbors == 2 or neighbors == 3
		else
			return neighbors == 3
		end
	end, stddraw},
	Wireworld = {function()
		return math.random(0, 3)
	end, function(x, y)
		local state = grid[y][x]
		if state == 0 then
			return 0
		elseif state == 1 then
			local neighbors = 0
			if grid[y-1][x] == 2 then neighbors = neighbors+1 end
			if grid[y-1][x+1] == 2 then neighbors = neighbors+1 end
			if grid[y][x+1] == 2 then neighbors = neighbors+1 end
			if grid[y+1][x+1] == 2 then neighbors = neighbors+1 end
			if grid[y+1][x] == 2 then neighbors = neighbors+1 end
			if grid[y+1][x-1] == 2 then neighbors = neighbors+1 end
			if grid[y][x-1] == 2 then neighbors = neighbors+1 end
			if grid[y-1][x-1] == 2 then neighbors = neighbors+1 end
			if neighbors == 2 or neighbors == 3 then
				return 2
			end
			return 1
		elseif state == 2 then
			return 3
		elseif state == 3 then
			return 1
		end
	end, function(state, x, y)
		if state == 0 then
			return
		elseif state == 1 then
			render.setRGBA(255, 128, 0, 255)
		elseif state == 2 then
			render.setRGBA(255, 255, 255, 255)
		elseif state == 3 then
			render.setRGBA(0, 128, 255, 255)
		end
		render.drawRect((x-1)*xm, (y-1)*ym, xm, ym)
	end}
}
setName(rulename)
local seed, rule, draw = unpack(rules[rulename])
rules = nil
setmetatable(grid, {
	__index = function(tbl, key)
		return rawget(tbl, (key-1)%h+1)
	end
})
local meta = {
	__index = function(tbl, key)
		return rawget(tbl, (key-1)%w+1)
	end
}
local thread = coroutine.create(function()
	for y=1, h do
		local row = {}
		setmetatable(row, rowmeta)
		for x=1, w do
			row[x] = seed(x, y)
		end
		grid[y] = row
		grid2[y] = {}
		yield()
	end
end)
hook.add("think", "init", function()
	local state = coroutine.status(thread)
	if state == "suspended" then
		if math.max(quotaUsed(), quotaAverage()) < threshold then
			coroutine.resume(thread)
		end
	elseif state == "dead" then
		hook.remove("think", "init")
		local timebetween = 0.5
		local nexttime = timer.systime()+timebetween
		render.createRenderTarget("main")
		local bg = Color(0, 0, 0)
		thread = coroutine.create(function()
			while true do
				local now = timer.systime()
				if now >= nexttime then
					for y=1, h do
						local row = grid[y]
						local row2 = grid2[y]
						for x=1, w do
							row2[x] = rule(x, y)
						end
						yield()
					end
					for y=1, h do
						local row = grid[y]
						local row2 = grid2[y]
						for x=1, w do
							row[x] = row2[x]
						end
						yield()
					end
					nexttime = now+timebetween
				end
				render.selectRenderTarget("main")
				for y=1, h do
					render.setColor(bg)
					render.drawRect(0, (y-1)*ym, 1024, ym)
					local row = grid[y]
					for x=1, w do
						draw(row[x], x, y)
					end
					yield("main")
				end
				coroutine.yield()
			end
		end)
		hook.add("render", "render", function()
			render.setFilterMag(1)
			render.setFilterMin(1)
			if math.max(quotaUsed(), quotaAverage()) < threshold then
				coroutine.resume(thread)
			end
			render.setRGBA(255, 255, 255, 255)
			render.selectRenderTarget()
			render.setRenderTargetTexture("main")
			render.drawTexturedRect(0, 0, render.getResolution())
		end)
	end
end)
