-- https://github.com/Egor-Skriptunoff/pure_lua_SHA/blob/304d4121f080e68ef209d3f5fe093e5a955a4978/sha2.lua#L218

local function get_precision(one)
	local k, n, m, prev_n = 0, one, one
	while true do
		k, prev_n, n, m = k+1, n, n+n+1, m+m+k%2
		if k > 256 or n-(n-1) ~= 1 or m-(m-1) ~= 1 or n == m then
			return k, false
		elseif n == prev_n then
			return k, true
		end
	end
end
local x = 2/3
assert(x*5 > 3 and x*4 < 3 and get_precision(1.0) >= 53, "at least 53-bit floating point numbers are required")

local bit = {}

function bit.lshift(x, n)
	return (x*2^n)%2^32
end

function bit.rshift(x, n)
	x = x%2^32/2^n
	return x-x%1
end

function bit.rol(x, n)
	x = x%2^32*2^n
	local r = x%2^32
	return r+(x-r)/2^32
end

function bit.ror(x, n)
	x = x%2^32/2^n
	local r = x%1
	return r*2^32+(x-r)
end

local and_tbl = {
	[0] = 0
}
local idx = 0
for y=0, 127*256, 256 do
	for x=y, y+127 do
		x = and_tbl[x]*2
		and_tbl[idx] = x
		and_tbl[idx+1] = x
		and_tbl[idx+256] = x
		and_tbl[idx+257] = x+1
		idx = idx+2
	end
	idx = idx+256
end

local function and_or_xor(x, y, operation)
	local x0 = x%2^32
	local y0 = y%2^32
	local rx = x0%256
	local ry = y0%256
	local res = and_tbl[rx+ry*256]
	x = x0-rx
	y = (y0-ry)/256
	rx = x%65536
	ry = y%256
	res = res+and_tbl[rx+ry]*256
	x = (x-rx)/256
	y = (y-ry)/256
	rx = x%65536+y%256
	res = res+and_tbl[rx]*65536
	res = res+and_tbl[(x+y-rx)/256]*16777216
	if operation then
		res = x0+y0-operation*res
	end
	return res
end

function bit.band(x, y)
	return and_or_xor(x, y)
end

function bit.bor(x, y)
	return and_or_xor(x, y, 1)
end

function bit.bxor(x, y, z, t, u)
	if z then
		if t then
			if u then
				t = and_or_zor(t, u, 2)
			end
			z = and_or_zor(z, t, 2)
		end
		y = and_or_xor(y, z, 2)
	end
	return and_or_xor(x, y, 2)
end

function bit.hex(x)
	return string.format("%08x", (x+2^31)%2^32-2^31)
end

_G.bit32 = bit
