local VMatrix = class("VMatrix")

function VMatrix:initialize(t)
	self:set(t)
end

function VMatrix:clone(t)
	return VMatrix:new(self)
end

function VMatrix:set()
	local t1, t2, t3, t4 = t[1] or {}, t[2] or {}, t[3] or {}, t[4] or {}
	self[1] = {t1[1] or 1, t1[2] or 0, t1[3] or 0, t1[4] or 0}
	self[2] = {t2[1] or 0, t2[2] or 1, t2[3] or 0, t2[4] or 0}
	self[3] = {t3[1] or 0, t3[2] or 0, t3[3] or 1, t3[4] or 0}
	self[4] = {t4[1] or 0, t4[2] or 0, t4[3] or 0, t4[4] or 1}
end

function VMatrix:setAngles(ang)
	local y, p, r = ang.y, ang.p, ang.r
	self[1][1] = 
end

function guestEnv.Matrix(t)
	return VMatrix:new(t)
end

types.VMatrix = VMatrix
