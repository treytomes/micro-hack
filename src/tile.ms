Tile = {}

Tile.init = function(char, foregroundColor, backgroundColor=null, blocksMovement=false, blocksVision=false)
	self.char = char
	self.foregroundColor = foregroundColor
	self.backgroundColor = math.coalesce(backgroundColor, Color.black)
	self.blocksMovement = blocksMovement
	self.blocksVision = blocksVision

	self.isCurrentlyVisible = not features.ENABLE_FOV
	self.hasBeenVisited = not features.ENABLE_FOV
end function

Tile.draw = function(tileDisplay, x, y)
	fg = self.foregroundColor
	if fg isa Color then fg = fg.str
	bg = self.backgroundColor
	if bg isa Color then bg = bg.str
	
	tileDisplay.setCellColor x, y, fg
	tileDisplay.setCellBackColor x, y, bg
	tileDisplay.setCell x, y, self.char
end function

Tile.drawDim = function(tileDisplay, x, y)
	fg = self.foregroundColor
	if fg isa Color then fg = fg.darker.str else fg = "#444444"
	bg = self.backgroundColor
	if bg isa Color then bg = bg.darker.str else bg = color.black
	tileDisplay.setCellColor x, y, fg
	tileDisplay.setCellBackColor x, y, bg
	tileDisplay.setCell x, y, self.char
end function

make = function(char, foregroundColor, backgroundColor, blocksMovement=false, blocksVision=false)
	t = (new Tile)
	t.init(char, foregroundColor, backgroundColor, blocksMovement, blocksVision)
	return t
end function
