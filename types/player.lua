local Player = class("Player", types.Entity)

function Player:initialize(data)
	data = data or {}
	data.class = data.class or "player"
	types.Entity.initialize(self, data)
	self._name = data.name or "garry"
	self._steamID = data.steamID or "STEAM_0:1:7099"
	self._steamID64 = data.steamID64 or "76561197960279927"
end
function Player:getName()
	return self._name
end
function Player:getSteamID()
	return self._steamID
end
function Player:getSteamID64()
	return self._steamID64
end

types.Player = Player
