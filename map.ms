import "tile"

Map = {}
Map.height = 26
Map.width = 68
Map.tiles = []

Map.make = function()
	m = new Map
	for y in range(m.height)
		row = []
		for x in range(m.width)
			row.push tile.Tile.makeWall
		end for
		m.tiles.push row
	end for
	return m
end function

Map.blocksMovement = function(x, y)
	return self.tiles[y][x].blocksMovement
end function

Map.blocksVision = function(x, y)
	return self.tiles[y][x].blocksVision
end function

Map.drawTile = function(x, y)
	self.tiles[y][x].draw x, y
end function

Map.draw = function()
	for y in range(self.height)
		for x in range(self.width)
			self.drawTile x, y
		end for
	end for
end function
