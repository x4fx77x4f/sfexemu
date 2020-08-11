local Color = class("Color")

function Color:initialize(r, g, b, a)
	r = math.max(math.min(r or 255, 255), 0)
	g = math.max(math.min(g or 255, 255), 0)
	b = math.max(math.min(b or 255, 255), 0)
	a = math.max(math.min(a or 255, 255), 0)
	self._r = r
	self._g = g
	self._b = b
	self._a = a
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

return Color
