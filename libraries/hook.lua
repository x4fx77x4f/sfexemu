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

function hook_run(chip, hookname, ...)
	if not chip.hooks[hookname] then
		return false
	end
	if hookname == "render" then
		chip.inrenderhook = true
	end
	for name, func in pairs(chip.hooks[hookname]) do
		chip:run(func, ...)
		if chip.state ~= STATE_RUNNING then
			return false
		end
	end
	chip.inrenderhook = false
	return true
end

guestEnv.hook = hook
