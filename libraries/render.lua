local render = {}

function render.clear(color, depth)
	render.setColor(color)
	render.drawRectFast(0, 0, curchip.canvas.width, curchip.canvas.height)
end

definedfonts = {
	DebugFixed = '13px monospace',
	DebugFixedSmall = '13px monospace',
	Default = '11px sans-serif',
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

function render.drawRect(x, y, w, h)
	curchip.ctx:fillRect(x, y, w, h)
end
render.drawRectFast = render.drawRect

local TEXT_H_CENTER = 1
local TEXT_H_RIGHT = 2
local TEXT_V_CENTER = 1
local TEXT_V_TOP = 4
function render.drawSimpleText(x, y, text, xalign, yalign)
	local w, h = curchip.ctx:measureText(text).width, curchip.fontheight
	local xo = xalign == TEXT_H_CENTER and w/2 or xalign == TEXT_H_RIGHT and w or 0
	local yo = yalign == TEXT_V_CENTER and h/2 or yalign == TEXT_V_TOP   and 0 or h
	curchip.ctx:fillText(text, x-xo, y+yo-curchip.fontyo)
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
		curchip.ctx:fillText(line, x-xo, y+h*i-curchip.fontyo)
	end
end

function render.getTextSize(text)
	local m = curchip.ctx:measureText(text)
	return m.width, curchip.fontheight
end

function render.setBackgroundColor(color)
	curchip.bgcolor = color._fillstyle
end

function render.setColor(color)
	curchip.ctx.fillStyle = color._fillstyle
	curchip.ctx.strokeStyle = color._strokestyle
end

function render.setFont(font)
	font = assert(definedfonts[font], "Font does not exist.")
	curchip.ctx.font = font[1]
	curchip.fontheight = font[2]
	curchip.fontyo = font[3] or 0
end

function render.setRGBA(r, g, b, a)
	r = math.max(math.min(r, 255), 0)
	g = math.max(math.min(g, 255), 0)
	b = math.max(math.min(b, 255), 0)
	a = math.max(math.min(a, 255), 0)
	local str = string.format("rgba(%f, %f, %f, %f)", r, g, b, a/255)
	curchip.ctx.fillStyle = str
	curchip.ctx.strokeStyle = str
end

function render_predraw(chip)
	chip = chip or curchip
	local font = definedfonts.Default
	chip.ctx.font = font[1]
	chip.ctx.fontheight = font[2]
	chip.ctx.fontyo = font[3] or 0
	chip.ctx.fillStyle = chip.bgcolor
	chip.ctx:fillRect(0, 0, chip.canvas.width, chip.canvas.height)
	chip.ctx.fillStyle = "#ffffff"
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
	chip.ctx.fillStyle = "#000000"
	chip.ctx:fillRect(0, 0, chip.canvas.width, chip.canvas.height)
	chip.ctx.fillStyle = "#00ffff"
	local h = 26
	chip.ctx.font = h..'px Arial, sans-serif'
	chip.ctx:fillText("Error occurred in Starfall:", 0, h)
	chip.ctx.fillStyle = "#ff0000"
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
			local measure = chip.ctx:measureText(lastPhrase..splitChar..w).width
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
		chip.ctx:fillText(line, 0, y)
	end
	chip.ctx.fillStyle = "#ffffff"
	local file, line = chip.error:match("(.-):(%d+): ")
	local file2 = file:match('^%[string "starfall/(.+)"%]$')
	file = file and (file2 or "[JS]") or "[unknown]"
	line = line or "[unknown]"
	chip.ctx:fillText("File: "..file, 0, y+h)
	chip.ctx:fillText("Line: "..line, 0, y+h+h)
end

guestEnv.render = render
