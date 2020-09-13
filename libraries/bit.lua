local a = (2^31)-1
local b = (2^32)-2
guestEnv.bit = {
	arshift = bit32.arshift,
	band = function(a, b)
		return a & b
	end,
	bnot = function(a)
		return ~a
	end,
	bor = function(a, b)
		return a | b
	end,
	bswap = bit32.bswap,
	bxor = function(a, b)
		return a ~ b
	end,
	lshift = function(a, b)
		return a << b
	end,
	rol = bit32.rol,
	ror = bit32.ror,
	rshift = function(a, b)
		return a >> b
	end,
	tobit = function(n)
		while n > a do
			n = n-b
		end
		return n
	end,
	tohex = function(n)
		n = n & 0xffffffff
		n = string.format("%x", n)
		return string.rep("0", 8-#n)..n
	end
}
