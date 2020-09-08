--@client
if type(loadstring("//")) == "function" then
	local black = Color(0, 0, 0)
	hook.add("render", "render", function()
		render.setBackgroundColor(black)
		render.setRGBA(0, 255, 0, 255)
		render.setFont("DermaLarge")
		render.drawText(8, 8, "Real")
	end)
else
	local red = Color(255, 0, 0)
	hook.add("render", "render", function()
		render.setColor(red)
		render.setFont("DermaLarge")
		render.drawText(8, 8, "Emulated")
	end)
end
