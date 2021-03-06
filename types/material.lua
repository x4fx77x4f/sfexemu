local Material = class("Material")

materials = {}
materialsi = 0

local defaultkeys = {
	["$alpha"] = {"SetInt", 1},
	["$alphatestreference"] = {"SetInt", 0},
	["$ambientonly"] = {"SetInt", 0},
	["$basemapalphaphongmask"] = {"SetInt", 0},
	["$basetexture"] = {"SetUndefined"},
	["$basetexturetransform"] = {"SetMatrix"},
	["$blendtintbybasealpha"] = {"SetInt", 0},
	["$blendtintcoloroverbase"] = {"SetInt", 0},
	["$bumpframe"] = {"SetInt", 0},
	["$bumptransform"] = {"SetMatrix"},
	["$cloakcolortint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$cloakfactor"] = {"SetFloat", 0},
	["$cloakpassenabled"] = {"SetInt", 0},
	["$color"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$color2"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$depthblend"] = {"SetInt", 0},
	["$depthblendscale"] = {"SetFloat", 50},
	["$detail"] = {"SetUndefined"},
	["$detailblendfactor"] = {"SetFloat", 1},
	["$detailblendmode"] = {"SetInt", 0},
	["$detailframe"] = {"SetInt", 0},
	["$detailscale"] = {"SetInt", 4},
	["$detailtexturetransform"] = {"SetMatrix"},
	["$detailtint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$displacementmap"] = {"SetUndefined"},
	["$emissiveblendenabled"] = {"SetInt", 0},
	["$emissiveblendscrollvector"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$emissiveblendstrength"] = {"SetFloat", 0},
	["$emissiveblendtint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$envmap"] = {"SetUndefined"},
	["$envmapcontrast"] = {"SetFloat", 0},
	["$envmapframe"] = {"SetInt", 0},
	["$envmapfresnel"] = {"SetFloat", 0},
	["$envmapfresnelminmaxexp"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$envmaplightscale"] = {"SetFloat", 0},
	["$envmaplightscaleminmax"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$envmapmask"] = {"SetUndefined"},
	["$envmapmaskframe"] = {"SetInt", 0},
	["$envmapmasktransform"] = {"SetMatrix"},
	["$envmapsaturation"] = {"SetFloat", 1},
	["$envmaptint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$flags"] = {"SetInt", 201334784},
	["$flashlightnolambert"] = {"SetInt", 0},
	["$flashlighttexture"] = {"SetUndefined"},
	["$flashlighttextureframe"] = {"SetInt", 0},
	["$fleshbordernoisescale"] = {"SetFloat", 0},
	["$fleshbordersoftness"] = {"SetFloat", 0},
	["$fleshbordertint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$fleshborderwidth"] = {"SetFloat", 0},
	["$fleshdebugforcefleshon"] = {"SetInt", 0},
	["$flesheffectcenterradius1"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$flesheffectcenterradius2"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$flesheffectcenterradius3"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$flesheffectcenterradius4"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$fleshglobalopacity"] = {"SetFloat", 0},
	["$fleshglossbrightness"] = {"SetFloat", 0},
	["$fleshinteriorenabled"] = {"SetInt", 0},
	["$fleshscrollspeed"] = {"SetFloat", 0},
	["$fleshsubsurfacetint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$frame"] = {"SetInt", 0},
	["$invertphongmask"] = {"SetInt", 0},
	["$lightwarptexture"] = {"SetUndefined"},
	["$linearwrite"] = {"SetInt", 0},
	["$phong"] = {"SetInt", 0},
	["$phongalbedotint"] = {"SetFloat", 0},
	["$phongboost"] = {"SetFloat", 0},
	["$phongexponent"] = {"SetFloat", 0},
	["$phongexponenttexture"] = {"SetUndefined"},
	["$phongfresnelranges"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$phongtint"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$phongwarptexture"] = {"SetUndefined"},
	["$refractamount"] = {"SetFloat", 0},
	["$rimlight"] = {"SetInt", 0},
	["$rimlightboost"] = {"SetFloat", 0},
	["$rimlightexponent"] = {"SetFloat", 0},
	["$rimmask"] = {"SetInt", 0},
	["$seamless_base"] = {"SetInt", 0},
	["$seamless_detail"] = {"SetInt", 0},
	["$seamless_scale"] = {"SetFloat", 0},
	["$selfillum_envmapmask_alpha"] = {"SetInt", 0},
	["$selfillumfresnel"] = {"SetInt", 0},
	["$selfillumfresnelminmaxexp"] = {"SetVector", 0.000000, 0.000000, 0.000000},
	["$selfillumtint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$separatedetailuvs"] = {"SetInt", 0},
	["$srgbtint"] = {"SetVector", 1.000000, 1.000000, 1.000000},
	["$time"] = {"SetInt", 0},
	["$treesway"] = {"SetInt", 0},
	["$treeswayfalloffexp"] = {"SetFloat", 1.5},
	["$treeswayheight"] = {"SetFloat", 1000},
	["$treeswayradius"] = {"SetFloat", 300},
	["$treeswayscrumblefalloffexp"] = {"SetFloat", 1},
	["$treeswayscrumblefrequency"] = {"SetFloat", 12},
	["$treeswayscrumblespeed"] = {"SetFloat", 5},
	["$treeswayscrumblestrength"] = {"SetFloat", 10},
	["$treeswayspeed"] = {"SetFloat", 1},
	["$treeswayspeedhighwindmultiplier"] = {"SetFloat", 2},
	["$treeswayspeedlerpend"] = {"SetFloat", 6},
	["$treeswayspeedlerpstart"] = {"SetFloat", 3},
	["$treeswaystartheight"] = {"SetFloat", 0.10000000149012},
	["$treeswaystartradius"] = {"SetFloat", 0.20000000298023},
	["$treeswaystatic"] = {"SetInt", 0},
	["$treeswaystrength"] = {"SetFloat", 10}
}

function Material:initialize(shader, texture)
	materialsi = materialsi+1
	self._shader = shader
	self._name = string.format("sf_material_%s_%d", shader, materialsi)
	materials[self._name] = self
	self._keys = table.copy(defaultkeys)
	if texture then
		self._keys["$basetexture"] = {"SetString", texture}
	end
end

function Material:setTextureURL(key, url, cb, done)
	assert(key == "$basetexture", "other keys not implemented")
	cb = cb or function() end
	done = done or function() end
	self._img = self._img or document:createElement("img")
	function self._img.onload()
		cb(self, url, self._img.width, self._img.height)
		done(self, url)
	end
	local curchip = curchip
	function self._img.onerror()
		curchip:onerror(debug.traceback("FUCK"))
	end
	self._img.src = url
end

types.Material = Material
