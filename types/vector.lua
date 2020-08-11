local Vector = class("Vector")

function Vector:initialize(x, y, z)
	self._x = x or 0
	self._y = y or 0
	self._z = z or 0
end

function Vector:add(v)
	self._x = self._x+v.x
	self._y = self._y+v.y
	self._z = self._z+v.z
end

function Vector:clone()
	return Vector:new(self._x, self._y, self._z)
end

function Vector:getColor()
	return types.Color:new(self._x, self._y, self._z)
end

function Vector:izZero()
	return self._x == 0 and self._y == 0 and self._z == 0
end

function Vector:mul(n)
	self._x = self._x*n
	self._y = self._y*n
	self._z = self._z*n
end

function Vector:round(idp)
	self._x = math.round(self._x, idp)
	self._y = math.round(self._y, idp)
	self._z = math.round(self._z, idp)
end

function Vector:set(v)
	self._x = v.x or 0
	self._y = v.y or 0
	self._z = v.z or 0
end

function Vector:setX(x)
	self._x = x or 0
	return x
end

function Vector:setY(y)
	self._y = y or 0
	return y
end

function Vector:setZ(z)
	self._z = z or 0
	return z
end

function Vector:setZero()
	self._x = 0
	self._y = 0
	self._z = 0
end

function Vector:sub(v)
	self._x = self._x-v.x
	self._y = self._y-v.y
	self._z = self._z-v.z
end

function Vector:vdiv(v)
	self._x = self._x/v.x
	self._y = self._y/v.y
	self._z = self._z/v.z
end

function Vector:vmul(v)
	self._x = self._x*v.x
	self._y = self._y*v.y
	self._z = self._z*v.z
end

function Vector:__add(v)
	return Vector:new(
		self._x+v.x,
		self._y+v.y,
		self._z+v.z
	)
end

function Vector:__div(v)
	v = type(v) == "number" and {x=v, y=v, z=v} or v
	return Vector:new(
		self._x/v.x,
		self._y/v.y,
		self._z/v.z
	)
end

function Vector:__eq(v)
	return self._x == v.x and self._y == v.y and self._z == v.z
end

function Vector:__mul(v)
	v = type(v) == "number" and {x=v, y=v, z=v} or v
	return Vector:new(
		self._x*v.x,
		self._y*v.y,
		self._z*v.z
	)
end

function Vector:__sub(v)
	return Vector:new(
		self._x-v.x,
		self._y-v.y,
		self._z-v.z
	)
end

function Vector:__tostring()
	return string.format("%s %s %s", self._x, self._y, self._z)
end

function Vector:__unm()
	return Vector:new(
		-self._x,
		-self._y,
		-self._z
	)
end

function guestEnv.Vector(...)
	return Vector:new(...)
end

types.Vector = Vector
