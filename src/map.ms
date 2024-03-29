Map = {}
Map.height = 64 // 26
Map.width = 64 // 68

Map.stairsUp = point.zero
Map.stairsDown = point.zero

Map.make = function(levelNumber)
	m = new Map
	m.levelNumber = levelNumber
	m.tiles = []
	m.entities = []
	m.player = null

	for y in range(m.height)
		row = []
		for x in range(m.width)
			row.push tiles.makeWall()
		end for
		m.tiles.push row
	end for
	return m
end function

Map.getTile = function(x, y)
	if 0 <= x and x < self.width and 0 <= y and y < self.height then
		return self.tiles[y][x]
	end if
	return tiles.makeWall()
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

// Get a list of all entities at a point.
Map.getEntitiesAt = function(pnt)
	lst = []
	for e in self.entities
		if e.position.equals(pnt) then
			lst.push(e)
		end if
	end for
	return lst
end function

// Get the first entity found at a point.
Map.getEntityAt = function(pnt)
	for e in self.entities
		if e.position.equals(pnt) then
			return e
		end if
	end for
	return null
end function

Map.isEntityAt = function(pnt)
	return self.getEntityAt(pnt) != null
end function

Map.removeEntity = function(entity)
	if self.entities.len == 0 then
		return
	end if
	for n in range(0, self.entities.len - 1)
		// I don't really know why I need the position check.  Maybe the equality comparison doesn't go deep enough?
		// TODO: Does this resolve the pickUp bug?
		if self.entities[n].equals(entity) then //and self.entities[n].position == entity.position then
			self.entities.remove(n)
			return
		end if
	end for
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
		
		if not self.isVisible(pnt.x, pnt.y) then
			if not self.blocksMovement(pnt.x, pnt.y) then
				if not self.isEntityAt(pnt) then
					return pnt
				end if
			end if
		end if
	end while
end function

Map.clear = function()
	for y in range(0, SCREEN_MAX_Y - 1)
		for x in range(0, SCREEN_MAX_X)
			Display.map.setCell x, y, 24 * 16 + 2, Color.white, Color.white
		end for
	end for
end function

Map.drawTile = function(x, y, renderOffset=null)
	//if self.isEntityAt(point.make(x, y)) then return
	
	rx = x
	ry = y
	if renderOffset != null then
		rx += renderOffset.x
		ry += renderOffset.y
	end if

	if not math.isInRange(rx, 0, SCREEN_MAX_X) or not math.isInRange(ry, 0, SCREEN_MAX_Y) then
		return
	end if

	if not math.isInRange(x, 0, self.width - 1) or not math.isInRange(y, 0, self.height - 1) then
		Display.map.setCell rx, ry, 24 * 16 + 2, Color.white, Color.white
		return
	end if

	t = self.tiles[y][x]

	if t.isCurrentlyVisible then
		t.draw(Display.map, rx, ry)

		// // Draw minimap.
		// c = t.foregroundColor.str()
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	else if t.hasBeenVisited then
		t.drawDim(Display.map, rx, ry)

		// // Draw minimap.
		// c = t.foregroundColor.str()
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	else
		Display.map.setCell rx, ry, 24 * 16 + 2, Color.white, Color.white

		// // Draw minimap.
		// c = Color.gray
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	end if
end function

Map.drawMiniMap = function()
	cellSize = 2
	renderWidth = self.width * cellSize
	renderHeight = self.height * cellSize

	borderSize = 2
	borderX = constants.PIXEL_WIDTH - renderWidth - borderSize * 2
	borderY = constants.PIXEL_HEIGHT - renderHeight - borderSize * 2
	borderWidth = renderWidth + borderSize * 2
	borderHeight = renderHeight + borderSize * 2
	Display.pixels.drawRect borderX, borderY, borderWidth, borderHeight, Color.brown, borderSize

	for y in range(0, self.height)
		for x in range(0, self.width)
			tile = self.getTile(x, y)
			rx = constants.PIXEL_WIDTH - (renderWidth - x * cellSize) - borderSize - 1
			ry = constants.PIXEL_HEIGHT - (renderHeight - y * cellSize) - borderSize - 1
			if tile.hasBeenVisited then
				c = tile.mapColor
			else
				c = Color.gray
			end if
			Display.pixels.drawRect rx, ry, cellSize, cellSize, c.str(), 1
		end for
	end for

	for e in self.entities
		ex = e.position.x
		ey = e.position.y

		if not self.isVisible(ex, ey) then
			continue
		end if

		c = e.tile.mapColor

		rx = constants.PIXEL_WIDTH - (renderWidth - ex * cellSize) - borderSize - 1
		ry = constants.PIXEL_HEIGHT - (renderHeight - ey * cellSize) - borderSize - 1

		// Display.pixels.setPixel rx, ry, c
		Display.pixels.drawRect rx, ry, cellSize, cellSize, c.str(), 1
	end for
end function

Map.draw_v1 = function(renderOffset)
	halfHeight = constants.TILE_DISPLAY_HEIGHT / 2 - 1
	halfWidth = constants.TILE_DISPLAY_WIDTH / 2 - 1

	self.drawMiniMap()

	player = Service.world.player
	for y in range(player.position.y - halfHeight, player.position.y + halfHeight + 1 - 1) // The -1 at the end here accounts for a HUD rendering problem. 
		for x in range(player.position.x - halfWidth, player.position.x + halfWidth + 1)
			self.drawTile x, y, renderOffset
		end for
	end for
end function

// In this version we draw the entire map to the TileDisplay, then use built-in functions to scroll the map later on.
Map.draw_v2 = function()
	for y in range(0, self.height - 1)
		for x in range(0, self.width - 1)
			self.drawTile x, y
		end for
	end for
end function

// Map.getDrawInfo = function(x, y, renderOffset)
// 	//if self.isEntityAt(point.make(x, y)) then return
	
// 	rx = renderOffset.x + x
// 	ry = renderOffset.y + y

// 	if not math.isInRange(rx, 0, SCREEN_MAX_X) or not math.isInRange(ry, 0, SCREEN_MAX_Y) then
// 		clear
// 		print "ERROR: getDrawInfo called out of range"
// 		exit
// 		return
// 	end if
	
// 	if not math.isInRange(x, 0, self.width - 1) or not math.isInRange(y, 0, self.height - 1) then
// 		return [Color.gray, Color.black, "#"]
// 	end if

// 	t = self.tiles[y][x]

// 	if t.isCurrentlyVisible then
// 		return t.getDrawInfo(false)
// 	else if t.hasBeenVisited then
// 		return t.getDrawInfo(true)
// 	else
// 		return [Color.gray, Color.black, "#"]
// 	end if
// end function

// Map.draw = function(renderOffset)
// 	//halfHeight = self.height / 2
// 	//halfWidth = self.width / 2
	
// 	halfHeight = constants.TILE_DISPLAY_HEIGHT / 2
// 	halfWidth = constants.TILE_DISPLAY_WIDTH / 2
// 	minx = -renderOffset.x
// 	maxx = minx + SCREEN_MAX_X
// 	miny = -renderOffset.y
// 	maxy = miny + SCREEN_MAX_Y
	
// 	display.row = constants.TILE_DISPLAY_HEIGHT - 1; display.column = 0
// 	curRun = null
// 	for y in range(maxy, miny)	// (since Y is inverted)
// 		for x in range(minx, maxx)
// 			info = self.getDrawInfo(Map.display, x, y, renderOffset)
// 			if curRun[:2] == info[:2] then
// 				curRun[2] += info[2]
// 			else
// 				if curRun then
// 					dsp.setCell x, y, curRun[2], curRun[1], curRun[0]
// 				end if
// 				curRun = info
// 			end if
// 		end for
// 	end for

// 	// display.backColor = curRun[0]
// 	// display.color = curRun[1]
// 	// // careful about the very last one -- we don't want to trigger a scroll
// 	// display.print curRun[2][:-1]
// 	// display.setCellBackColor display.column, display.row, curRun[2][0]
// 	// display.setCellColor display.column, display.row, curRun[2][1]
// 	// display.setCell display.column, display.row, curRun[2][2]
// end function
