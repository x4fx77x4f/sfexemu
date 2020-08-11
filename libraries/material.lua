local material = {}

keyvalues = dofile("keyvalues.lua")

shaders = {
	UnlitGeneric = true,
	VertexLitGeneric = true,
	Refract_DX90 = true,
	Water_DX90 = true,
	Sky_DX9 = true,
	gmodscreenspace = true,
	Modulate_DX9 = true
}

function material.create(shader)
	assert(shaders[shader], "Tried to use unsupported shader: "..shader)
	return types.Material:new(shader)
end

materialsGame = {
	["radon/starfall2"] = true
}

function material.load(path)
	if string.find(path, "^!") then
		return assert(materials[string.gsub(path, "^!", "")], "This material doesn't exist or is blacklisted")
	end
	assert(materialsGame[path], "This material doesn't exist or is blacklisted")
	local mat = types.Material:new(false, path)
	fetch(prefixes.materials..string.normalizePath(path)..".vmt", function(success, response, text)
		if not success then
			print(string.format("Got HTTP %d %s on path %q", response.status, response.statusText, path))
			error("This material doesn't exist or is blacklisted")
		end
	end)
	return mat
end

guestEnv.material = material
