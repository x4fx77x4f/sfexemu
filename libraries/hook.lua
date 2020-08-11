local hook = {}

function hook.add(hookname, name, func)
	curchip.hooks[hookname] = curchip.hooks[hookname] or {}
	curchip.hooks[hookname][name] = func
end

function hook.remove(hookname, name)
	if not curchip.hooks[hookname] then
		return
	end
	curchip.hooks[hookname][name] = nil
end

function hook.run(hookname, name, ...)
	if not curchip.hooks[hookname] then
		return
	end
	for name, func in pairs(curchip.hooks[hookname]) do
		local ret = {func(...)}
		if ret[1] then
			return table.unpack(ret)
		end
	end
end

guestEnv.hook = hook
