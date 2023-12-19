Tile = {}

Tile.init = function(char, foregroundColor, backgroundColor=null, blocksMovement=false, blocksVision=false)
	self.char = char
	self.foregroundColor = foregroundColor
	self.backgroundColor = math.coalesce(backgroundColor, Color.black)
	self.blocksMovement = blocksMovement
	self.blocksVision = blocksVision
	self.name = ""
	self.isCurrentlyVisible = not features.ENABLE_FOV
	self.hasBeenVisited = not features.ENABLE_FOV
end function

Tile.getDrawInfo = function(dim=false)
	fg = self.foregroundColor
	bg = self.backgroundColor
	if dim then
	    if fg isa Color then fg = fg.darker.str else fg = "#444444"
		if bg isa Color then bg = bg.darker.str else bg = color.black
	else
		if fg isa Color then fg = fg.str
		if bg isa Color then bg = bg.str	
	end if
	return [bg, fg, self.char]
end function

Tile.draw = function(dsp, x, y)
	fg = self.foregroundColor
	if fg isa Color then fg = fg.str
	bg = self.backgroundColor
	if bg isa Color then bg = bg.str
	dsp.setCell x, y, self.char, fg, bg
end function

Tile.drawDim = function(dsp, x, y)
	fg = self.foregroundColor
	if fg isa Color then fg = fg.darker.str else fg = "#444444"
	bg = self.backgroundColor
	if bg isa Color then bg = bg.darker.str else bg = color.black
	dsp.setCell x, y, self.char, fg, bg
end function

Tile.setName = function(name)
	self.name = name
	return self
end function

make = function(char, foregroundColor, backgroundColor, blocksMovement=false, blocksVision=false)
	t = (new Tile)
	t.init(char, foregroundColor, backgroundColor, blocksMovement, blocksVision)
	return t
end function
