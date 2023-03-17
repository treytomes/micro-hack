import "math"
import "point"
import "tile"

SCREEN_MAX_X = 67
SCREEN_MAX_Y = 25

Map = {}
Map.height = 64 // 26
Map.width = 64 // 68

Map.make = function()
	m = new Map
	m.tiles = []
	m.entities = []
	m.player = null

	for y in range(m.height)
		row = []
		for x in range(m.width)
			row.push tile.Tile.makeWall
		end for
		m.tiles.push row
	end for
	return m
end function

Map.getTile = function(x, y)
	if 0 <= x and x < self.width and 0 <= y and y < self.height then
		return self.tiles[y][x]
	end if
	return tile.Tile.makeWall()
end function

Map.blocksMovement = function(x, y)
	if 0 <= x and x < self.width and 0 <= y and y < self.height then
		return self.getTile(x, y).blocksMovement
	end if
	return true
end function

Map.blocksVision = function(x, y)
	if 0 <= x and x < self.width and 0 <= y and y < self.height then
		return self.getTile(x, y).blocksVision
	end if
	return true
end function

Map.isVisible = function(x, y)
	if 0 <= x and x < self.width and 0 <= y and y < self.height then
		return self.getTile(x, y).isCurrentlyVisible
	end if
	return false
end function

Map.getEntityAt = function(pnt)
	for e in self.entities
		if e != null then
			if e.position.x == pnt.x and e.position.y == pnt.y then
				return e
			end if
		end if
	end for
	return null
end function

Map.isEntityAt = function(pnt)
	return self.getEntityAt(pnt) != null
end function

// Find a walkable place in the map to place an entity.
Map.findSpawnPoint = function()
	while true
		// I brought in the range a bit, as you will never spawn on the map edge.
		pnt = point.make(math.random(1, self.width - 2), math.random(1, self.height - 2))
		if not self.blocksMovement(pnt.x, pnt.y) then
			if not self.isEntityAt(pnt) then
				return pnt
			end if
		end if
	end while
end function

// Find a place to spawn an entity that is also outside of the player's range of vision.
Map.findHiddenSpawnPoint = function()
	while true
		// I brought in the range a bit, as you will never spawn on the map edge.
		pnt = point.make(math.random(1, self.width - 2), math.random(1, self.height - 2))
		if not self.blocksVision(pnt.x, pnt.y) then
			if not self.blocksMovement(pnt.x, pnt.y) then
				if not self.isEntityAt(pnt) then
					return pnt
				end if
			end if
		end if
	end while
end function

Map.clearScreen = function(display)
	for y in range(0, SCREEN_MAX_Y)
		for x in range(0, SCREEN_MAX_X)
			display.setCellColor(x, y, color.black)
			display.setCellBackColor(x, y, color.gray)
			display.setCell(x, y, "#")
		end for
	end for
end function

Map.drawTile = function(display, x, y, renderOffset)
	rx = renderOffset.x + x
	ry = renderOffset.y + y

	if not math.isInRange(rx, 0, SCREEN_MAX_X) or not math.isInRange(ry, 0, SCREEN_MAX_Y) then
		return
	end if

	if not math.isInRange(x, 0, self.width - 1) or not math.isInRange(y, 0, self.height - 1) then
		display.setCellColor rx, ry, color.black
		display.setCellBackColor rx, ry, color.gray
		display.setCell rx, ry, "#"
		return
	end if

	t = self.tiles[y][x]

	if t.isCurrentlyVisible then
		t.draw(display, rx, ry)
	else if t.hasBeenVisited then
		display.setCellColor rx, ry, "#444444"
		display.setCellBackColor rx, ry, color.black
		display.setCell rx, ry, t.char
	else
		display.setCellColor rx, ry, color.black
		display.setCellBackColor rx, ry, color.gray
		display.setCell rx, ry, "#"
	end if
end function

Map.draw = function(display, player, renderOffset)
	halfHeight = self.height / 2
	halfWidth = self.width / 2
	for y in range(player.position.y - halfHeight, player.position.y + halfHeight)
		for x in range(player.position.x - halfWidth, player.position.x + halfWidth)
			self.drawTile(display, x, y, renderOffset)
		end for
	end for
end function
