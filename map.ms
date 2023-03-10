import "point"
import "tile"

Map = {}
Map.height = 26
Map.width = 68

Map.make = function()
	m = new Map
	m.tiles = []
	m.entities = []

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

Map.isEntityAt = function(pnt)
	for e in self.entities
		if e.position.x == pnt.x and e.position.y == pnt.y then
			return true
		end if
	end for
	return false
end function

Map.findSpawnPoint = function()
	found = false
	x = 0
	y = 0
	while not found
		x = floor(rnd() * self.width)
		y = floor(rnd() * self.height)
		if not self.blocksMovement(x, y) then
			if not self.isEntityAt(point.Point.make(x, y)) then
			 found = true
			end if
		end if
	end while
	return point.Point.make(x, y)
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
