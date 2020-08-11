local Color = class("Color")

function Color:initialize(r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255
	self._r = r
	self._g = g
	self._b = b
	self._a = a
	r = math.clamp(r, 0, 255)
	g = math.clamp(g, 0, 255)
	b = math.clamp(b, 0, 255)
	a = math.clamp(a, 0, 255)
	self._fillstyle = string.format("rgba(%f, %f, %f, %f)", r, g, b, a/255)
	self._strokestyle = self._fillstyle
end

function Color:set(color)
	self:initialize(color.r, color.g, color.b, color.a)
end
function Color:setR(r)
	self:initialize(r, self.g, self.b, self.a)
	return self.r
end
function Color:setG(g)
	self:initialize(self.r, g, self.b, self.a)
	return self.g
end
function Color:setB(b)
	self:initialize(self.r, self.g, b, self.a)
	return self.b
end
function Color:setA(a)
	self:initialize(self.r, self.g, self.b, a)
	return self.a
end

function Color:clone()
	return Color:new(self.r, self.g, self.b, self.a)
end

function Color:hsvToRGB()
	-- https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB
	local h, s, v = self._r%360, math.clamp(self._g, 0, 1), math.clamp(self._b, 0, 1)
	local c = v*s
	local h2 = h/60
	local x = c*(1-math.abs(h2%2-1))
	local r2, g2, b2
	if 0 <= h2 and h2 <= 1 then
		r2, g2, b2 = c, x, 0
	elseif 1 < h2 and h2 <= 2 then
		r2, g2, b2 = x, c, 0
	elseif 2 < h2 and h2 <= 3 then
		r2, g2, b2 = 0, c, x
	elseif 3 < h2 and h2 <= 4 then
		r2, g2, b2 = 0, x, c
	elseif 4 < h2 and h2 <= 5 then
		r2, g2, b2 = x, 0, c
	elseif 5 < h2 and h2 <= 6 then
		r2, g2, b2 = c, 0, x
	else
		r2, g2, b2 = 0, 0, 0
	end
	local m = v-c
	local r, g, b = r2+m, g2+m, b2+m
	return Color:new(r*255, g*255, b*255, self._a)
end

function Color:rgbToHSV()
	-- https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB
	local r, g, b = math.clamp(self._r/255, 0, 1), math.clamp(self._g/255, 0, 1), math.clamp(self._b/255, 0, 1)
	local x2 = math.max(r, g, b)
	local v = x2
	local x1 = math.min(r, g, b)
	local c = x2-x1
	local h
	if c == 0 then
		h = 0
	elseif v == r then
		h = 60*(  (g-b)/c)
	elseif v == g then
		h = 60*(2+(b-r)/c)
	elseif v == b then
		h = 60*(4+(r-g)/c)
	end
	local s = v == 0 and 0 or c/v
	return Color:new(h, s, v, self._a)
end

function Color:__index(key)
	if key == "r" or key == "g" or key == "b" or key == "a" then
		return rawget(self, "_"..key)
	end
	return rawget(self, key)
end

function Color:__newindex(key, value)
	if key == "r" or key == "g" or key == "b" or key == "a" then
		rawset(self, "_"..key, value)
		self:initialize(
			rawget(self, "_r"),
			rawget(self, "_g"),
			rawget(self, "_b"),
			rawget(self, "_a")
		)
	else
		rawset(self, key, value)
	end
end

function Color:__tostring()
	return string.format("%s %s %s %s", self.r, self.g, self.b, self.a)
end

types.Color = Color
