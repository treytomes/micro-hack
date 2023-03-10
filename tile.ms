Tile = {}
Tile.blocksMovement = false
Tile.blocksVision = false
Tile.char = " "
Tile.backgroundColor = color.black
Tile.foregroundColor = color.gray

Tile.makeFloor = function()
	t = new Tile
	t.char = "."
	return t
end function

Tile.makeWall = function()
	t = new Tile
	t.blocksMovement = true
	t.blocksVision = true
	t.char = "#"
	t.foregroundColor = color.silver
	return t
end function

Tile.draw = function(x, y)
	text.setCellColor x, y, self.foregroundColor
	text.setCellBackColor x, y, self.backgroundColor
	text.setCell x, y, self.char
end function
