HeadsUpDisplay = {}

HeadsUpDisplay.initTiles = function(displayNumber)
	display(displayNumber).mode = displayMode.tile
	display(displayNumber).tileSet = file.loadImage("assets/OEM437_24_ex.png")
	display(displayNumber).tileSetTileSize = [16, 24]
	display(displayNumber).cellSize = [16, 24]
	display(displayNumber).extent = [constants.UI_DISPLAY_WIDTH, constants.UI_DISPLAY_HEIGHT]
	return display(displayNumber)
end function

HeadsUpDisplay.make = function(displayNumberFront, displayNumberBack)
	dsp = new HeadsUpDisplay
	dsp.display = dsp.initTiles(displayNumberFront)
	dsp.displayBack = dsp.initTiles(displayNumberBack)
	return dsp
end function

HeadsUpDisplay.setCellBackColor = function(x, y, backColor)
	if backColor isa Color then
		backColor = backColor.str()
	end if
	self.displayBack.setCell x, y, constants.TILE_INDEX_SOLID
	self.displayBack.setCellTint x, y, backColor
end function

HeadsUpDisplay.setCell = function(x, y, tile, color="#FFFFFF", backColor = "#00000000")
	if tile isa string then
		tile = code(tile)
	end if
	if color isa Color then
		color = color.str()
	end if
	self.display.setCell x, y, tile
	self.display.setCellTint x, y, color
	self.setCellBackColor x, y, backColor
end function

HeadsUpDisplay.clear = function()
	for y in range(0, constants.UI_DISPLAY_YMAX)
		for x in range(0, constants.UI_DISPLAY_XMAX)
			self.setCell x, y, 0, color.black, color.clear
		end for
	end for
end function

HeadsUpDisplay.print = function(text, x, y, color="#FFFFFF", backColor="#00000000")
	for ch in text
		self.setCell x, y, code(ch), color, backColor
		x += 1
	end for
end function

return HeadsUpDisplay