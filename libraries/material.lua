local material = {}

--keyvalues = dofile("keyvalues.lua")
if not keyvalues then
	keyvalues = {
		decode = function()
			return {
				UnlitGeneric = true
			}
		end
	}
end

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
	local mat = types.Material:new(shader)
	return mat
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
	mat._img = document:createElement("img")
	path = prefixes.materials..string.normalizePath(path)
	local curchip = curchip
	fetch(path..".vmt", function(success, response, text)
		if not success then
			print(string.format("Got HTTP %d %s while fetching %q", response.status, response.statusText, response.url))
			curchip:onerror(debug.traceback("This material doesn't exist or is blacklisted"))
			return
		end
		local success, data = xpcall(keyvalues.decode, function(err)
			curchip:onerror(debug.traceback(tostring(err)))
		end, text)
		if not success then
			return
		end
		local shader
		for k in pairs(data) do
			shader = k
			break
		end
		function mat._img:onload()
			if curchip.activemat2 then
				curchip.activemat = mat._img
			end
		end
		mat._img.src = prefixes.materials..string.normalizePath(data[shader]["$basetexture"])..".png"
	end)
	return mat
end

guestEnv.material = material
