--@name SFExEmu
--@client
--include drawtext.txt
--local debugtext, debugfont = dofile("drawtext.txt")()
local ideal = 1/60
local font1 = render.createFont("DejaVu Sans Mono", 64)
local font2 = render.createFont("Verdana", 24)
local font3 = render.createFont("DejaVu Sans Mono", 24)
hook.add("render", "render", function()
	local mult = timer.frametime()/ideal
	local now = timer.systime()
	render.setBackgroundColor(Color(timer.systime()*25%360, 0.5, 0.5):hsvToRGB())
	local x, y, z = math.sin(now)*32, math.sin(now*0.7)*32, (math.sin(now*1.3)+2)*16
	render.setRGBA(0, 0, 0, 127)
	render.drawRectFast(64+x+z, 160+y+z, 384, 192)
	render.setRGBA(230, 230, 230, 255)
	render.drawRectFast(64+x, 160+y, 384, 192)
	render.setRGBA(0, 0, 0, 255)
	render.setFont(font1)
	render.drawSimpleText(256+x, 256+y-34, "SFExEmu", 1, 1)
	render.setRGBA(95, 95, 95, 255)
	render.setFont(font2)
	render.drawSimpleText(256+x, 256+y+16, "Specify a main file with", 1, 1)
	render.setFont(font3)
	render.drawSimpleText(256+x, 256+y+40, "?main=yourfilehere.txt", 1, 1)
	local cx, cy = render.cursorPos()
	if cx then
		render.setRGBA(0, 0, 0, 255)
		render.drawRect(cx-2, cy-2, 4, 4)
		render.setRGBA(255, 255, 255, 255)
		render.drawRect(cx-1, cy-1, 2, 2)
	end
	if debugtext then
		render.setFont(debugfont)
		debugtext(string.format(
			" now: %s\nmult: %s\n   x: %s\n   y: %s\n   z: %s\n  cx: %s\n  cy: %s",
			now,
			mult,
			x,
			y,
			z,
			cx,
			cy
		), 0, 0, 3)
	end
end)
