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

Map.clear = function(dsp)
	for y in range(0, SCREEN_MAX_Y - 1)
		for x in range(0, SCREEN_MAX_X)
			dsp.setCell x, y, "#", color.black, color.gray
		end for
	end for
end function

Map.drawTile = function(dsp, x, y, renderOffset=null)
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
		dsp.setCell rx, ry, "#", color.black, color.gray
		return
	end if

	t = self.tiles[y][x]

	if t.isCurrentlyVisible then
		t.draw(dsp, rx, ry)

		// // Draw minimap.
		// c = t.foregroundColor.str()
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	else if t.hasBeenVisited then
		t.drawDim(dsp, rx, ry)

		// // Draw minimap.
		// c = t.foregroundColor.str()
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	else
		dsp.setCell rx, ry, "#", color.black, color.gray

		// // Draw minimap.
		// c = color.gray
		// Display.pixels.setPixel constants.PIXEL_WIDTH - x - 1, constants.PIXEL_HEIGHT - y - 1, c
	end if
end function

Map.drawMiniMap = function()
	Display.pixels.drawRect constants.PIXEL_WIDTH - self.width - 2, constants.PIXEL_HEIGHT - self.height - 2, self.width + 2, self.height + 2, color.brown, 2

	for y in range(0, self.height)
		for x in range(0, self.width)
			if self.getTile(x, y).hasBeenVisited then
				tile = self.getTile(x, y)
				c = tile.foregroundColor.str()
				Display.pixels.setPixel constants.PIXEL_WIDTH - (self.width - x) - 1, constants.PIXEL_HEIGHT - (self.height - y) - 1, c
			else
				c = color.gray
				Display.pixels.setPixel constants.PIXEL_WIDTH - (self.width - x) - 1, constants.PIXEL_HEIGHT - (self.height - y) - 1, c
			end if
		end for
	end for

	for e in self.entities
		x = e.position.x
		y = e.position.y
		c = e.tile.foregroundColor.str()

		Display.pixels.setPixel constants.PIXEL_WIDTH - (self.width - x) - 1, constants.PIXEL_HEIGHT - (self.height - y) - 1, c
	end for
end function

Map.draw_v1 = function(display, player, renderOffset)
	halfHeight = constants.TILE_DISPLAY_HEIGHT / 2 - 1
	halfWidth = constants.TILE_DISPLAY_WIDTH / 2 - 1

	self.drawMiniMap()

	for y in range(player.position.y - halfHeight, player.position.y + halfHeight + 1 - 1) // The -1 at the end here accounts for a HUD rendering problem. 
		for x in range(player.position.x - halfWidth, player.position.x + halfWidth + 1)
			self.drawTile display, x, y, renderOffset
		end for
	end for
end function

// In this version we draw the entire map to the TileDisplay, then use built-in functions to scroll the map later on.
Map.draw_v2 = function(dsp)
	for y in range(0, self.height - 1)
		for x in range(0, self.width - 1)
			self.drawTile dsp, x, y
		end for
	end for
end function

Map.getDrawInfo = function(display, x, y, renderOffset)
	//if self.isEntityAt(point.make(x, y)) then return
	
	rx = renderOffset.x + x
	ry = renderOffset.y + y

	if not math.isInRange(rx, 0, SCREEN_MAX_X) or not math.isInRange(ry, 0, SCREEN_MAX_Y) then
		clear
		print "ERROR: getDrawInfo called out of range"
		exit
		return
	end if
	
	if not math.isInRange(x, 0, self.width - 1) or not math.isInRange(y, 0, self.height - 1) then
		return [color.gray, color.black, "#"]
	end if

	t = self.tiles[y][x]

	if t.isCurrentlyVisible then
		return t.getDrawInfo(false)
	else if t.hasBeenVisited then
		return t.getDrawInfo(true)
	else
		return [color.gray, color.black, "#"]
	end if
end function

Map.draw = function(dsp, player, renderOffset)
	//halfHeight = self.height / 2
	//halfWidth = self.width / 2
	
	halfHeight = constants.TILE_DISPLAY_HEIGHT / 2
	halfWidth = constants.TILE_DISPLAY_WIDTH / 2
	minx = -renderOffset.x
	maxx = minx + SCREEN_MAX_X
	miny = -renderOffset.y
	maxy = miny + SCREEN_MAX_Y
	
	display.row = constants.TILE_DISPLAY_HEIGHT - 1; display.column = 0
	curRun = null
	for y in range(maxy, miny)	// (since Y is inverted)
		for x in range(minx, maxx)
			info = self.getDrawInfo(display, x, y, renderOffset)
			if curRun[:2] == info[:2] then
				curRun[2] += info[2]
			else
				if curRun then
					dsp.setCell x, y, curRun[2], curRun[1], curRun[0]
				end if
				curRun = info
			end if
		end for
	end for

	// display.backColor = curRun[0]
	// display.color = curRun[1]
	// // careful about the very last one -- we don't want to trigger a scroll
	// display.print curRun[2][:-1]
	// display.setCellBackColor display.column, display.row, curRun[2][0]
	// display.setCellColor display.column, display.row, curRun[2][1]
	// display.setCell display.column, display.row, curRun[2][2]
end function
