for k, v in pairs(_ENV) do
	print(k, v)
end
if getfenv and setfenv then
	print(1, _ENV)
	print(2, getfenv() or "nil??")
	local function foo()
		return getfenv() or "nil??"
	end
	local env = {
		getfenv = getfenv,
		print = print
	}
	print(3, env)
	setfenv(foo, env)
	print(4, foo())
end
