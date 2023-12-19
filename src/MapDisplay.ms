MapDisplay = {}

MapDisplay.initTiles = function(displayNumber)
	dsp = new TileDisplay // Create a detached TileDisplay.
	// display(displayNumber).mode = displayMode.tile
	dsp.tileSet = file.loadImage("assets/OEM437_8.png")
	dsp.tileSetTileSize = 8
	dsp.cellSize = 16
	dsp.extent = [constants.TILE_DISPLAY_WIDTH, constants.TILE_DISPLAY_HEIGHT]
	return dsp
end function

MapDisplay.make = function(displayNumberFront, displayNumberBack)
	dsp = new MapDisplay
	dsp.isActive = false

	dsp.displayNumberFront = displayNumberFront
	dsp.displayNumberBack = displayNumberBack

	dsp.activeDisplay = 0

	dsp.display0 = dsp.initTiles(displayNumberFront)
	dsp.display0Back = dsp.initTiles(displayNumberBack)

	dsp.display1 = dsp.initTiles(displayNumberFront)
	dsp.display1Back = dsp.initTiles(displayNumberBack)
	
	dsp.display = dsp.display0
	dsp.displayBack = dsp.display0Back
	dsp.display.install dsp.displayNumberFront
	dsp.displayBack.install dsp.displayNumberBack

	return dsp
end function

MapDisplay.flip = function()
	if self.activeDisplay == 0 then
		self.activeDisplay = 1

		self.display = self.display1
		self.displayBack = self.display1Back

		self.display0.install self.displayNumberFront
		self.display0Back.install self.displayNumberBack
	else
		self.activeDisplay = 0

		self.display = self.display0
		self.displayBack = self.display0Back

		self.display1.install self.displayNumberFront
		self.display1Back.install self.displayNumberBack
	end if
	return self
end function

MapDisplay.setCellBackColor = function(x, y, backColor)
	if backColor isa Color then
		backColor = backColor.str()
	end if
	self.displayBack.setCell x, y, constants.TILE_INDEX_SOLID
	self.displayBack.setCellTint x, y, backColor
end function

MapDisplay.setCell = function(x, y, tile, color="#FFFFFF", backColor = "#00000000")
	if tile isa string then
		tile = code(tile)
	end if
	if tile > 255 then
		tile = code("?")
	end if
	
	if color isa Color then
		color = color.str()
	end if
	self.display.setCell x, y, tile
	self.display.setCellTint x, y, color
	self.setCellBackColor x, y, backColor
end function

MapDisplay.clear = function(fg="#000000", bg="#00000000")
	for y in range(0, constants.TILE_DISPLAY_YMAX)
		for x in range(0, constants.TILE_DISPLAY_XMAX)
			self.setCell x, y, 0, fg, bg
		end for
	end for
end function

MapDisplay.print = function(text, x, y, color="#FFFFFF", backColor="#00000000")
	for ch in text
		self.setCell x, y, code(ch), color, backColor
		x += 1
	end for
end function

return MapDisplay