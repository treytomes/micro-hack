Tile = {}
Tile.blocksMovement = false
Tile.blocksVision = false
Tile.char = " "
Tile.backgroundColor = color.black
Tile.foregroundColor = color.gray

Tile.make = function(char, foregroundColor, backgroundColor, blocksMovement, blocksVision)
	t = new Tile
	t.char = char
	t.foregroundColor = foregroundColor
	t.backgroundColor = backgroundColor
	t.blocksMovement = blocksMovement
	t.blocksVision = blocksVision

	t.isCurrentlyVisible = false
	t.hasBeenVisited = false
	
	return t
end function

Tile.makeFloor = function()
	return Tile.make(".", "#663311", color.black, false, false)
end function

Tile.makeWall = function()
	return Tile.make("#", color.brown, color.black, true, true)
end function

Tile.draw = function(tileDisplay, x, y)
	tileDisplay.setCellColor x, y, self.foregroundColor
	tileDisplay.setCellBackColor x, y, self.backgroundColor
	tileDisplay.setCell x, y, self.char
end function
