js = require("js")
window = js.global
document = window.document
class = dofile("middleclass.lua")

--sf_timebuffer_cl = 0.006
sf_timebuffer_cl = 0.015
sf_timebuffersize_cl = 100
sf_timebuffersoftlock_cl = false
sf_ram_max_cl = 1500000

pathprefix = "starfall/"

function string.normalizePath(path)
	local null = string.find(path, "\x00", 1, true)
	if null then
		path = string.sub(path, 1, null-1)
	end
	local tbl = {}
	local i = 1
	for line in (path.."/"):gmatch("(.-)[\\/]+") do
		tbl[i] = line
		i = i+1
	end
	if not tbl[2] then
		return path
	end
	i = 1
	while i <= #tbl do
		if tbl[i] == "." or tbl[i] == "" then
			table.remove(tbl, i)
		elseif tbl[i] == ".." then
			table.remove(tbl, i)
			if i > 1 then
				i = i-1
				table.remove(tbl, i)
			end
		else
			i = i+1
		end
	end
	return table.concat(tbl, "/")
end

function table.copy(t, lookup_table)
	if t == nil then
		return nil
	end
	local meta = getmetatable(t)
	local copy = {}
	setmetatable(copy, meta)
	for i, v in pairs(t) do
		if type(v) ~= "table" then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then
				copy[i] = lookup_table[v]
			else
				copy[i] = table.copy(v, lookup_table)
			end
		end
	end
	return copy
end

types = {}
types.Color = dofile("types/color.lua")
types.Entity = dofile("types/entity.lua")
types.Player = dofile("types/player.lua")

guestEnv = {}
dofile("libraries/builtins.lua")
dofile("libraries/hook.lua")
dofile("libraries/render.lua")
dofile("libraries/string.lua")

chips = {}
chipi = 100

function systime()
	return window.performance:now()
end

instance = class("chip")

function instance:onerror(err)
	self.error = err
	print(err)
	self.state = STATE_STOPPED
	self.window.classList:add("errored")
	render_drawerror(self)
end

function instance:movingCPUAverage()
	return self.cpu_average+(self.cpu_total-self.cpu_average)*self.cpuQuotaRatio
end

function instance:runWithOps(func, ...)
	assert(self.state == STATE_RUNNING, debug.traceback("Instance not running"))
	local oldSysTime = systime()-self.cpu_total
	local function cpuCheck()
		self.cpu_total = systime()-oldSysTime
		local usedRatio = self:movingCPUAverage()/self.cpuQuota
		if usedRatio > 1 then
			error("CPU Quota exceeded.")
			--self:onerror(debug.traceback("CPU Quota exceeded."))
		elseif usedRatio > self.cpu_softquota then
			--self:onerror("CPU Quota warning.")
		end
	end
	debug.sethook(cpuCheck, "", 2000)
	curchip = self
	local tbl = {xpcall(func, function(err)
		self:onerror(debug.traceback(tostring(err), 2))
		return err
	end, ...)}
	curchip = nil
	debug.sethook()
	if tbl[1] then
		self.cpu_total = systime()-oldSysTime
		local usedRatio = self:movingCPUAverage()/self.cpuQuota
		if usedRatio > 1 then
			return {false}
		end
	end
	return tbl
end

function instance:runWithoutOps(func, ...)
	curchip = self
	local tbl = {xpcall(func, function(err)
		self:onerror(debug.traceback(tostring(err), 2))
		return err
	end, ...)}
	curchip = nil
	return tbl
end

function instance:setName(str)
	self.name = str
	self.labelName.textContent = str
end

STATE_LOADING = 0
STATE_STOPPED = 1
STATE_RUNNING = 2

function instance:initialize(main)
	self.owner = types.Player:new({
		index = 1
	})
	self.player = self.owner
	self.chip = types.Entity:new({
		class = "starfall_processor",
		model = "models/spacecode/sfchip.mdl",
		owner = self.owner,
		index = chipi
	})
	chips[chipi] = self
	chipi = chipi+1

	self.main = main
	self.hooks = {}
	self.env = table.copy(guestEnv)
	self.env._G = self.env
	self.env._ENV = self.env

	if sf_timebuffersoftlock_cl then
		self.cpuQuota = sf_timebuffer_cl
		self.cpuQuotaRatio = 1/sf_timebuffersize_cl
		self.run = self.runWithOps
	else
		self.cpuQuota = math.huge
		self.cpuQuotaRatio = 0
		self.run = self.runWithoutOps
	end

	self.window = document:createElement("div")
	self.window.classList:add("instance")

	self.label = document:createElement("label")
	self.label.classList:add("label")
	self.labelName = document:createElement("span")
	self.label:append(self.labelName)
	self.window:append(self.label)

	self.canvas = document:createElement("canvas")
	self.canvas.width = 512
	self.canvas.height = 512
	self.ctx = self.canvas:getContext("2d")
	self.window:append(self.canvas)
	document.body:append(self.window)

	self.bgcolor = "#000000"
	render_predraw(self)

	self:setName("Generic (No-Name)")
	self.state = STATE_LOADING

	self.cpu_total = 0
	self.cpu_average = 0
	self.cpu_softquota = 1

	local promise = window:fetch(pathprefix..main)
	promise["then"](promise, function(_, response)
		if response.ok then
			local promise = response:text()
			promise["then"](promise, function(_, code)
				-- StarfallEx's actual preprocessor is WAY OVERENGINEERED and will detect directives from anywhere in the file. Fuck that; I'm only gonna look at the beginning of the file since that's the only place anyone puts any of them.
				local canrunnow = true
				local needtofetch = {}
				for line in code:gmatch("(.-)\n") do
					local directive = line:match("^\x2d-@(%a+)")
					if directive then
						local parameters = line:match("^\x2d-@"..directive.." *(.-)$")
						if directive == "author" then
							self.author = parameters
						elseif directive == "client" then
							-- no-op
						elseif directive == "clientmain" then
							self:onerror(debug.traceback("You can't have a clientmain and client directive at the same time"))
						elseif directive == "include" then
							canrunnow = false
							table.insert(needtofetch, parameters)
						elseif directive == "includedir" then
							self:onerror(debug.traceback("\x2d-@includedir is not implemented"))
							return
						elseif directive == "model" then
							self.model = parameters
						elseif directive == "name" then
							self:setName(parameters)
						elseif directive == "server" then
							self:onerror(debug.traceback("This tool only supports clientside scripts"))
							return
						elseif directive == "superuser" then
							self:onerror(debug.traceback("\x2d-@superuser is not implemented"))
							return
						else
							-- no-op
						end
					elseif not line:find("^%s*$") then
						break
					end
				end
				self.includes = {}
				local func, err = load(code, main)
				if func then
					debug.setupvalue(func, 1, self.env)
					if canrunnow then
						self.state = STATE_RUNNING
						curchip = self
						self:run(func)
						curchip = nil
					else
						self.loadi = 0
						self.loadim = #needtofetch
						for _, path in pairs(needtofetch) do
							local promise = window:fetch(pathprefix..path)
							promise["then"](promise, function(_, response)
								if not response.ok then
									self:onerror(debug.traceback(string.format("HTTP %d %s", response.status, response.statusText)))
									return
								end
								if self.state ~= STATE_LOADING then
									return
								end
								local promise = response:text()
								promise["then"](promise, function(_, code)
									if self.state ~= STATE_LOADING then
										return
									end
									local func2, err = load(code, path)
									if func2 then
										self.includes[path] = func2
										self.loadi = self.loadi+1
										if self.loadi >= self.loadim then
											self.state = STATE_RUNNING
											self:run(func)
										end
									else
										self:onerror(debug.traceback(tostring(err)))
										return
									end
								end)
							end)
						end
					end
				else
					self:onerror(debug.traceback(tostring(err)))
				end
			end)
		else
			self:onerror(debug.traceback(string.format("HTTP %d %s", response.status, response.statusText)))
		end
	end)
end

local params = js.new(window.URLSearchParams, window.location.search)
local mainpath = params:get("main")
if mainpath == js.null then
	mainpath = "helloworld.lua"
end

function ontick()
	for index, chip in pairs(chips) do
		if chip.state == STATE_RUNNING then
			curchip = chip
			render_predraw()
			chip:run(guestEnv.hook.run, "think")
			chip:run(guestEnv.hook.run, "render")
			curchip = nil
		end
	end
	window:requestAnimationFrame(ontick)
end
window:requestAnimationFrame(ontick)

local els = document:getElementsByClassName("removeme")
while els[1] do
	els[1]:remove()
end

instance:new(mainpath)
