Tile = {}

Tile.make = function(char, foregroundColor, backgroundColor, blocksMovement=false, blocksVision=false)
	t = new Tile
	t.char = char
	t.foregroundColor = foregroundColor
	t.backgroundColor = backgroundColor
	t.blocksMovement = blocksMovement
	t.blocksVision = blocksVision

	t.isCurrentlyVisible = not features.ENABLE_FOV
	t.hasBeenVisited = not features.ENABLE_FOV
	
	return t
end function

Tile.draw = function(tileDisplay, x, y)
	tileDisplay.setCellColor x, y, self.foregroundColor
	tileDisplay.setCellBackColor x, y, self.backgroundColor
	tileDisplay.setCell x, y, self.char
end function

make = function(char, foregroundColor, backgroundColor, blocksMovement=false, blocksVision=false)
	return Tile.make(char, foregroundColor, backgroundColor, blocksMovement, blocksVision)
end function

makeFloor = function()
	return Tile.make(".", "#663311", color.black, false, false)
end function

makeStairsUp = function()
	return Tile.make("<", "#663311", color.black, false, false)
end function

makeStairsDown = function()
	return Tile.make(">", "#663311", color.black, false, false)
end function

makeWall = function()
	return Tile.make("#", color.brown, color.black, true, true)
end function

makeDoor = function()
	return Tile.make("+", color.black, color.brown, false, true)
end function

makeHidden = function()
	return Tile.make("#", color.black, color.gray, true, true)
end function
