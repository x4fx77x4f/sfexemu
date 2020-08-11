entities = {}
local Entity = class("Entity")

function Entity:initialize(data)
	data = data or {}
	self._class = data.class
	self._index = data.index
	self._model = data.model
	self._owner = data.owner
	self._valid = data.valid
	if self._index then
		entities[self._index] = self
	end
end
function Entity:entIndex()
	return self._index
end
function Entity:getModel()
	return self._model
end
function Entity:getOwner()
	return self._owner
end
function Entity:isPlayer()
	return self._class == "player"
end
function Entity:isValid()
	return self._valid
end

types.Entity = Entity
