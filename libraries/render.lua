local render = {}

local defaultmat = js.new(window.Image, 1, 1)
defaultmat.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bpUUrDnYQcchQO1koKuKoVShChVArtOpgcukXNGlIUlwcBdeCgx+LVQcXZ10dXAVB8APEydFJ0UVK/F9SaBHjwXE/3t173L0D/M0qU82eBKBqlpFJJYVcflUIviKEfgSQQExipj4niml4jq97+Ph6F+dZ3uf+HANKwWSATyCeZbphEW8QT29aOud94ggrSwrxOfG4QRckfuS67PIb55LDfp4ZMbKZeeIIsVDqYrmLWdlQiaeIo4qqUb4/57LCeYuzWq2z9j35C8MFbWWZ6zRHkcIiliBCgIw6KqjCQpxWjRQTGdpPevhHHL9ILplcFTByLKAGFZLjB/+D392axckJNymcBHpfbPtjDAjuAq2GbX8f23brBAg8A1dax19rAjOfpDc6WvQIGNwGLq47mrwHXO4Aw0+6ZEiOFKDpLxaB9zP6pjwwdAv0rbm9tfdx+gBkqav0DXBwCMRKlL3u8e5Qd2//nmn39wN3yXKpkdxPFQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB+QICw43F786Nw0AAAAMSURBVAjXY/j//z8ABf4C/tzMWecAAAAASUVORK5CYII="

function render.clear(color, depth)
	render.setColor(color)
	render.drawRectFast(0, 0, curchip.canvas.width, curchip.canvas.height)
end

function render.getResolution()
	return curchip.canvas.width, curchip.canvas.height
end

definedfonts = {
	DebugFixed = '13px monospace',
	DebugFixedSmall = '13px monospace',
	Default = 'italic 11px sans-serif',
	Marlett = '12px Marlett', -- shares some icons with webdings. look into that
	Trebuchet18 = '16px "Trebuchet MS", sans-serif',
	Trebuchet24 = '22px "Trebuchet MS", sans-serif',
	HudHintTextLarge = '12px sans-serif',
	HudHintTextSmall = '8px sans-serif',
	CenterPrintText = '14px sans-serif',
	HudSelectionText = '12px sans-serif',
	CloseCaption_Normal = 'italic 21px sans-serif',
	CloseCaption_Bold = 'italic 21px sans-serif',
	CloseCaption_BoldItalic = 'italic 21px sans-serif',
	ChatFont = '15px sans-serif',
	TargetID = '15px sans-serif',
	TargetIDSmall = '12px sans-serif',
	HL2MPTypeDeath = '64px HL2MPTypeDeath',
	BudgetLabel = '13px monospace',
	HudNumbers = '32px HudNumbers',
	DermaDefault = '11px sans-serif',
	DermaDefaultBold = '11px sans-serif',
	DermaLarge = '26px sans-serif'
}
for k, v in pairs(definedfonts) do
	definedfonts[k] = {v, tonumber(v:match("(%d+)px "))}
end
basefonts = {
	["akbar"] = 'Akbar, Arial, sans-serif',
	["coolvetica"] = 'Coolvetica, sans-serif',
	["roboto"] = 'Roboto, "Droid Sans", sans-serif',
	["roboto mono"] = '"Roboto Mono", monospace',
	["fontawesome"] = 'FontAwesome',
	["courier new"] = '"Courier New",  monospace',
	["verdana"] = 'Verdana, "DejaVu Sans", sans-serif',
	["arial"] = 'Arial, "Liberation Sans", sans-serif',
	["halflife2"] = 'HalfLife2',
	["hl2mp"] = 'hl2mp',
	["csd"] = 'csd',
	["tahoma"] = 'Tahoma, "DejaVu Sans", sans-serif',
	["trebuchet"] = '"Trebuchet MS", Trebuchet, "DejaVu Sans", sans-serif',
	["trebuchet ms"] = '"Trebuchet MS", "DejaVu Sans", sans-serif',
	["dejavu sans mono"] = '"DejaVu Sans Mono", monospace',
	["lucida console"] = '"Lucida Console", monospace',
	["times new roman"] = '"Times New Roman", serif',
	["default"] = 'sans-serif' -- undocumented
}
function render.createFont(font, size, weight, antialias, additive, shadow, outline, blur, extended)
	font = string.lower(font)
	assert(basefonts[font], "invalid font")
	size = tonumber(size) or 16
	weight = tonumber(weight) or 400
	blur = tonumber(blur) or 0
	antialias = antialias and true
	additive = additive and true
	shadow = shadow and true
	outline = outline and true
	extended = extended and true
	local name = string.format(
		"sf_screen_font_%s_%d_%d_%d_%d%d%d%d%d",
		font, size, weight, blur,
		antialias and 1 or 0,
		additive and 1 or 0,
		shadow and 1 or 0,
		outline and 1 or 0,
		extended and 1 or 0
	)
	if not definedfonts[name] then
		local prefix = ""
		if font == "coolvetica" or font == "tahoma" or font == "default" then
			prefix = "italic "..prefix
		end
		local fontstyle = prefix..(size-3).."px "..basefonts[font]
		definedfonts[name] = {fontstyle, size, 3}
	end
	return name
end
render.createFont("Default", 16, 400, false, false, false, false, 0)

function render.cursorPos(ply, screen)
	ply = ply or curchip.player
	assert(ply:isValid(), "Entity is not valid.")
	assert(ply._class == "player", "Entity isn't a player")
	screen = screen or curchip.screen
	assert(screen:isValid(), "Entity is not valid.")
	assert(screen == curchip.screen, "Invalid screen")
	if ply ~= curchip.player then
		return nil, nil
	end
	return curchip.cx, curchip.cy
end

function render.drawCircle(x, y, r)
	curchip.ctx.lineWidth = 1
	curchip.ctx:beginPath()
	curchip.ctx:arc(x, y, r, 0, 2*math.pi)
	curchip.ctx:stroke()
end

function render.drawLine(x1, y1, x2, y2)
	curchip.ctx.lineWidth = 1
	curchip.ctx:beginPath()
	curchip.ctx:moveTo(x1, y1)
	curchip.ctx:lineTo(x2, y2)
	curchip.ctx:stroke()
end

function render.drawPoly(poly)
	curchip.ctx:beginPath()
	for i, point in ipairs(poly) do
		curchip.ctx:lineTo(point.x, point.y)
	end
	curchip.ctx:closePath()
	curchip.ctx:fill()
end

function render.drawRect(x, y, w, h)
	curchip.ctx:fillRect(x, y, w, h)
end

function render.drawRectFast(x, y, w, h)
	curchip.ctx:fillRect(math.ceil(x-0.5), math.ceil(y-0.5), math.ceil(w-0.5), math.ceil(h-0.5))
end

function render.drawRectOutline(x, y, w, h)
	curchip.ctx.lineWidth = 1
	curchip.ctx:strokeRect(x+0.5, y+0.5, w-1, h-1)
end

function render.drawRoundedBox(r, x, y, w, h)
	render.drawRoundedBoxEx(r, x, y, w, h, true, true, true, true)
end

local d90 = math.pi/2
local tl1, tl2 = math.pi*0.75, math.pi*1.75
local tr1, tr2 = tl1+d90, tl2+d90
local br1, br2 = tr1+d90, tr2+d90
local bl1, bl2 = br1+d90, br2+d90
function render.drawRoundedBoxEx(r, x, y, w, h, tl, tr, bl, br)
	x = math.ceil(x-0.5)
	y = math.ceil(y-0.5)
	w = math.ceil(y-0.5)
	h = math.ceil(y-0.5)
	if r == 0 or not(tl or tr or bl or br) then
		curchip.ctx:fillRect(x, y, w, h)
		return
	end
	r = math.min(math.ceil(r-0.5), math.floor(w/2))
	curchip.ctx:fillRect(x, y+r, w, h-r-r)
	curchip.ctx:fillRect(x+r, y, w-r-r, h)
	if tl then
		curchip.ctx:beginPath()
		curchip.ctx:arc(x+r, y+r, r, tl1, tl2, false)
		curchip.ctx:fill()
	else
		curchip.ctx:fillRect(x, y, r, r)
	end
	if tr then
		curchip.ctx:beginPath()
		curchip.ctx:arc(x+w-r, y+r, r, tr1, tr2, false)
		curchip.ctx:fill()
	else
		curchip.ctx:fillRect(x+w-r, y, r, r)
	end
	if br then
		curchip.ctx:beginPath()
		curchip.ctx:arc(x+w-r, y+h-r, r, br1, br2, false)
		curchip.ctx:fill()
	else
		curchip.ctx:fillRect(x+w-r, y+h-r, r, r)
	end
	if bl then
		curchip.ctx:beginPath()
		curchip.ctx:arc(x+r, y+h-r, r, bl1, bl2, false)
		curchip.ctx:fill()
	else
		curchip.ctx:fillRect(x, y+h-r, r, r)
	end
end

local TEXT_H_CENTER = 1
local TEXT_H_RIGHT = 2
local TEXT_V_CENTER = 1
local TEXT_V_TOP = 4
function render.drawSimpleText(x, y, text, xalign, yalign)
	local w, h = curchip.ctx:measureText(text).width, curchip.fontheight
	local xo = xalign == TEXT_H_CENTER and w/2 or xalign == TEXT_H_RIGHT and w or 0
	local yo = yalign == TEXT_V_CENTER and h/2 or yalign == TEXT_V_TOP   and 0 or h
	curchip.ctx:fillText(text, math.ceil(x-xo-0.5), math.ceil(y+yo-curchip.fontyo-0.5))
end

function render.drawTexturedRect(x, y, w, h)
	if not curchip.white then
		-- https://stackoverflow.com/a/4231508
		curchip.ctx2:clearRect(0, 0, 1024, 1024)
		curchip.ctx2.fillStyle = curchip.ctx.fillStyle
		curchip.ctx2:fillRect(0, 0, 1024, 1024)
		curchip.ctx2.globalCompositeOperation = "destination-atop"
		curchip.ctx2:drawImage(curchip.activemat, 0, 00)
	end
	curchip.ctx.globalAlpha = curchip.alpha
	curchip.ctx:drawImage(curchip.white and curchip.activemat or curchip.canvas2, x, y, w, h)
	curchip.ctx.globalAlpha = 1
end

function render.drawTexturedRectFast(x, y, w, h)
	render.drawTexturedRect(math.ceil(x-0.5), math.ceil(y-0.5), math.ceil(w-0.5), math.ceil(h-0.5))
end

function render.drawTexturedRectRotated(x, y, w, h, r)
	if not curchip.white then
		curchip.ctx2:clearRect(0, 0, 1024, 1024)
		curchip.ctx2.fillStyle = curchip.ctx.fillStyle
		curchip.ctx2:fillRect(0, 0, 1024, 1024)
		curchip.ctx2.globalCompositeOperation = "destination-atop"
		curchip.ctx2:drawImage(curchip.activemat, 0, 00)
	end
	curchip.ctx:save()
	curchip.ctx:translate(x, y)
	curchip.ctx:rotate(r*math.pi/180)
	curchip.ctx.globalAlpha = curchip.alpha
	curchip.ctx:drawImage(curchip.white and curchip.activemat or curchip.canvas2, -w/2, -h/2, w, h)
	curchip.ctx.globalAlpha = 1
	curchip.ctx:restore()
end

function render.drawTexturedRectRotatedFast(x, y, w, h, r)
	render.drawTexturedRectRotated(math.ceil(x-0.5), math.ceil(y-0.5), math.ceil(w-0.5), math.ceil(h-0.5), r)
end

function render.drawTexturedRectUV(x, y, w, h, u1, v1, u2, v2)
	if not curchip.white then
		curchip.ctx2:clearRect(0, 0, 1024, 1024)
		curchip.ctx2.fillStyle = curchip.ctx.fillStyle
		curchip.ctx2:fillRect(0, 0, 1024, 1024)
		curchip.ctx2.globalCompositeOperation = "destination-atop"
		curchip.ctx2:drawImage(curchip.activemat, 0, 00)
	end
	local mat = curchip.white and curchip.activemat or curchip.canvas2
	local w2, h2 = mat.width, mat.height
	local x2, y2 = w2*u1, h2*v1
	curchip.ctx:drawImage(mat, x2, y2, w2*u2-x2, h2*v2-y2, x, y, w, h)
end

function render.drawTexturedRectUVFast(x, y, w, h, u1, v1, u2, v2)
	render.drawTexturedRectUV(math.ceil(x-0.5), math.ceil(y-0.5), math.ceil(w-0.5), math.ceil(h-0.5), u1, v1, u2, v2)
end

function render.drawText(x, y, text, alignment)
	-- Tabs have some really weird behavior in Starfall, particularly
	-- in non-left-aligned text and when there are non-tab characters
	-- before the tabs. I won't bother emulating all that though.
	text = text:gsub("\t", "     ")
	local i = 0
	local h = curchip.fontheight
	for line in (text.."\n"):gmatch("(.-)\n") do
		i = i+1
		local w = curchip.ctx:measureText(line).width
		local xo = alignment == TEXT_H_CENTER and w/2 or alignment == TEXT_H_RIGHT and w or 0
		curchip.ctx:fillText(line, math.ceil(x-xo-0.5), math.ceil(y+h*i-curchip.fontyo-0.5))
	end
end

function render.getScreenEntity()
	return curchip.inrenderhook and curchip.screen or nil
end

function render.getScreenInfo(ent)
	assert(ent:isValid(), "Entity is not valid.")
	assert(ent == curchip.screen, "Invalid screen")
	return {
		RatioX = curchip.canvas.width/curchip.canvas.height
	}
end

function render.getTextSize(text)
	local w = 0
	local i = 0
	for line in (text.."\n"):gmatch("(.-)\n") do
		i = i+1
		w = math.max(w, curchip.ctx:measureText(line).width)
	end
	return w, curchip.fontheight*i
end

function render.setBackgroundColor(color)
	curchip.bgcolor = color._fillstyle
end

function render.setColor(color)
	curchip.white = color._white
	curchip.alpha = color._a
	curchip.ctx.fillStyle = color._fillstyle
	curchip.ctx.strokeStyle = color._strokestyle
end

function render.setFont(font)
	font = assert(definedfonts[font], "Font does not exist.")
	curchip.ctx.font = font[1]
	curchip.fontheight = font[2]
	curchip.fontyo = font[3] or 0
end

function render.setMaterial(mat)
	if not mat then
		curchip.activemat = defaultmat
		curchip.activemat2 = nil
		return
	end
	curchip.activemat = mat._img or defaultmat
	curchip.activemat2 = not mat._img and mat
end

function render.setRGBA(r, g, b, a)
	r = math.max(math.min(r, 255), 0)
	g = math.max(math.min(g, 255), 0)
	b = math.max(math.min(b, 255), 0)
	a = math.max(math.min(a, 255), 0)/255
	local str = string.format("rgba(%f, %f, %f, %f)", r, g, b, a)
	curchip.alpha = a
	curchip.ctx.fillStyle = str
	curchip.ctx.strokeStyle = str
	curchip.white = r == 255 and g == 255 and b == 255
end

function render.createRenderTarget(name)
	assert(not curchip.targets[name], "A rendertarget with this name already exists!")
	local canvas = document:createElement("canvas")
	curchip.targets[name] = canvas
	canvas.width = 1024
	canvas.height = 1024
end
function render.destroyRenderTarget(name)
	if name == curchip.activetarget then
		return
	end
	assert(not curchip.targets[name], "Cannot destroy an invalid rendertarget.")
	curchip.targets[name] = nil
end
function render.renderTargetExists(name)
	return curchip.targets[name] and true
end
function render.selectRenderTarget(name)
	curchip.activetarget = name
	if name == nil then
		curchip.ctx = curchip.canvas:getContext("2d")
		return
	end
	assert(curchip.targets[name], "Invalid Rendertarget")
	curchip.ctx = curchip.targets[name]:getContext("2d")
end
function render.setRenderTargetTexture(name)
	curchip.activemat = curchip.targets[name] or defaultmat
end

function render_predraw(chip)
	chip = chip or curchip
	local font = definedfonts.Default
	chip.ctx.font = font[1]
	chip.fontheight = font[2]
	chip.fontyo = font[3] or 0
	chip.ctx.fillStyle = chip.bgcolor or "#000000"
	chip.ctx:fillRect(0, 0, chip.canvas.width, chip.canvas.height)
	chip.ctx.fillStyle = "#ffffff"
	chip.ctx.strokeStyle = chip.ctx.fillStyle
	chip.activemat = defaultmat
end

local function findbackwards(str, match)
	for i=#str, 1, -1 do
		if str:sub(i, i) == match then
			return i
		end
	end
end
function render_drawerror(chip)
	chip = chip or curchip
	local ctx = chip.canvas:getContext("2d")
	ctx.fillStyle = "#000000"
	ctx:fillRect(0, 0, chip.canvas.width, chip.canvas.height)
	ctx.fillStyle = "#00ffff"
	local h = 26
	ctx.font = h..'px Arial, sans-serif'
	ctx:fillText("Error occurred in Starfall:", 0, h)
	ctx.fillStyle = "#ff0000"
	if not chip.errorwrapped then
		-- https://stackoverflow.com/a/3960916
		-- doesn't handle strings without spaces in them
		local wa, phraseArray, lastPhrase, measure, splitChar = {}, {}, nil, 0, " "
		local i = 0
		for line in (chip.error:match("(.-)\nstack traceback:\n\t")..splitChar):gmatch("(.-)"..splitChar) do
			i = i+1
			wa[i] = line
		end
		lastPhrase = wa[1]
		if not wa[2] then
			chip.errorwrapped = wa
		end
		for i=2, #wa do
			local w = wa[i]
			local measure = ctx:measureText(lastPhrase..splitChar..w).width
			if measure < 512 then
				lastPhrase = lastPhrase..splitChar..w
			else
				table.insert(phraseArray, lastPhrase)
				lastPhrase = w
			end
			if i == #wa then
				table.insert(phraseArray, lastPhrase)
				break
			end
		end
		chip.errorwrapped = phraseArray
	end
	local y = h
	for index, line in ipairs(chip.errorwrapped) do
		local y2 = index*h+h
		y = math.max(y, y2)
		ctx:fillText(line, 0, y)
	end
	ctx.fillStyle = "#ffffff"
	local file, line = chip.error:match("(.-):(%d+): ")
	local file2 = file:match('^%[string "(.+)"%]$')
	file = file and (file2 or "[JS]") or "[unknown]"
	line = line or "[unknown]"
	ctx:fillText("File: "..file, 0, y+h)
	ctx:fillText("Line: "..line, 0, y+h+h)
end

function render.setFilterMag() end
function render.setFilterMin() end

render.TEXT_ALIGN_LEFT = 0
render.TEXT_ALIGN_CENTER = 1
render.TEXT_ALIGN_RIGHT = 2
render.TEXT_ALIGN_TOP = 3
render.TEXT_ALIGN_BOTTOM = 4

guestEnv.render = render
