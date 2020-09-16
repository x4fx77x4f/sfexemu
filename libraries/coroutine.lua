guestEnv.coroutine = {
	create = coroutine.create,
	resume = function(thread, ...)
		local retval = {coroutine.resume(thread, ...)}
		if not retval[1] then
			error(retval[2], 2)
		end
		table.remove(retval, 1)
		return table.unpack(retval)
	end,
	running = coroutine.running,
	status = coroutine.status,
	wrap = coroutine.wrap,
	yield = coroutine.yield
}
