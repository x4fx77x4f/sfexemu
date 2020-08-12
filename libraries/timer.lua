local timer = {}

function timer.adjust(name, delay, reps, func)
	local t = curchip.timers[name]
	if not t then
		return false
	end
	timer.create(name, delay, reps or t.reps, func or t.func)
	return true
end
function timer.create(name, delay, reps, func)
	curchip.timers[name] = {
		delay = delay and delay*1000 or 0,
		reps = reps ~= 0 and reps,
		func = func,
		lasttime = window.performance:now(),
		paused = false
	}
end
function timer.exists(name)
	return curchip.timers[name] and true
end

function timer.pause(name)
	if not curchip.timers[name] or curchip.timers[name].paused then
		return false
	end
	curchip.timers[name].paused = true
end
function timer.remove(name)
	curchip.timers[name] = nil
end
function timer.repsleft(name)
	if not curchip.timers[name] then
		return nil
	end
	return curchip.timers[name].reps or 0
end
function timer.toggle(name)
	if not curchip.timers[name] then
		return false
	end
	curchip.timers[name].paused = not curchip.timers[name].paused
end
function timer.unpause(name)
	if not curchip.timers[name] then
		return false
	end
	curchip.timers[name].paused = false
end
timer.start = timer.unpause
timer.stop = timer.pause

function timer.frametime()
	return curchip.dt or 1/60
end

local performance = window.performance
function timer.systime()
	return performance:now()/1000
end
timer.curtime = timer.systime
timer.realtime = timer.realtime

guestEnv.timer = timer
