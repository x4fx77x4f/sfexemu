--@name HSV to RGB and back
--@client
--@include drawtext.txt
local drawtext, font = dofile("drawtext.txt")()
hook.add("render", "render", function()
	local c = Color(timer.systime()*25%360, 0.5, 0.5)
	local c2 = c:hsvToRGB()
	local c3 = c2:rgbToHSV()
	local c4 = c3:hsvToRGB()
	render.setFont(font)
	render.setColor(c2)
	render.drawRectFast(0, 0, 256, 256)
	drawtext("c2", 0, 0, 3)
	render.setColor(c4)
	render.drawRectFast(0, 256, 256, 256)
	drawtext("c4", 0, 512, 9)
	render.setColor(c)
	render.drawRectFast(256, 0, 256, 256)
	drawtext("c1", 512, 0, 1)
	render.setColor(c3)
	render.drawRectFast(256, 256, 256, 256)
	drawtext("c3", 512, 512, 7)
	drawtext("original", 256, 0, 2)
	drawtext("converted", 256, 512, 8)
	drawtext("rgb", 0, 256, 6)
	drawtext("hsv", 512, 256, 4)
	drawtext(string.format(
		"t: %f\nh: %f\ns: %f\nv: %f\nr: %f\ng: %f\nb: %f\nd: %f",
		timer.systime(),
		c.r,
		c.g,
		c.b,
		c2.r,
		c2.g,
		c2.b,
		math.max(math.abs(c.r-c3.r), math.abs(c.g-c3.g), math.abs(c.b-c3.b))
	), 256, 256, 5)
end)
