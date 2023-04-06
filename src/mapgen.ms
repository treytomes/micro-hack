ensureImport "rect"

MapGenerator = {}

MapGenerator.drawFilledRect = function(map, x, y, width, height, tile)
	for y0 in range(y, y + height - 1)
		for x0 in range(x, x + width - 1)
			map.tiles[y0][x0] = tile()
		end for
	end for
end function

MapGenerator.drawPillar = function(map, x, y, tile)
	map.tiles[y - 1][x] = tile()
	map.tiles[y][x] = tile()
	map.tiles[y + 1][x] = tile()
	map.tiles[y][x - 1] = tile()
	map.tiles[y][x + 1] = tile()
end function

MapGenerator.drawHallway = function(map, room0, room1)
	tile = @tiles.makeFloor

	dx = -1
	if room0.centerX < room1.centerX then
		dx = 1
	end if
	dy = -1
	if room0.centerY < room1.centerY then
		dy = 1
	end if

	x = room0.centerX
	y = room0.centerY

	while x != room1.centerX
		map.tiles[y][x] = tile()
		x += dx
	end while

	while y != room1.centerY
		map.tiles[y][x] = tile()
		y += dy
	end while
end function

MapGenerator.drawDoors = function(map, room)
	tile = @tiles.makeDoor

	for x in range(room.left + 1, room.right - 1)
		if map.blocksMovement(x - 1, room.top - 1) and map.blocksMovement(x + 1, room.top - 1) and not map.blocksMovement(x, room.top - 1) then
			map.tiles[room.top - 1][x] = tile()
		end if
		if map.blocksMovement(x - 1, room.bottom + 1) and map.blocksMovement(x + 1, room.bottom + 1) and not map.blocksMovement(x, room.bottom + 1) then
			map.tiles[room.bottom + 1][x] = tile()
		end if
	end for
	for y in range(room.top + 1, room.bottom - 1)
		if map.blocksMovement(room.left - 1, y - 1) and map.blocksMovement(room.left - 1, y + 1) and not map.blocksMovement(room.left - 1, y) then
			map.tiles[y][room.left - 1] = tile()
		end if
		if map.blocksMovement(room.right + 1, y - 1) and map.blocksMovement(room.right + 1, y + 1) and not map.blocksMovement(room.right + 1, y) then
			map.tiles[y][room.right + 1] = tile()
		end if
	end for
end function

MapGenerator.randomPointInRoom = function(room)
	return point.make(math.random(room.left, room.right), math.random(room.top, room.bottom))
end function

MapGenerator.spawnItem = function(map, room, item)
	if item == null then
		return
	end if
	while true
		pnt = self.randomPointInRoom(room)
		if map.getEntityAt(pnt) == null then
			itemEntity = entities.makeItem(map, item, pnt)
			map.entities.push(itemEntity)
			return
		end if
	end while
end function

MapGenerator.decorateStairsUpRoom = function(map, room)
	map.stairsUp = point.make(room.centerX, room.centerY)
	map.tiles[room.centerY][room.centerX] = tiles.makeStairsUp()
end function

MapGenerator.decorateStairsDownRoom = function(map, room)
	map.stairsDown = point.make(room.centerX, room.centerY)
	map.tiles[room.centerY][room.centerX] = tiles.makeStairsDown()
end function

MapGenerator.decorateRoom = function(map, room)
	// 50% chance the room will have a prize!
	if math.random(0, 100) > 50 then
		item = itemDb.getRandomItemForLevel(map.levelNumber)
		self.spawnItem(map, room, item)
	end if
end function

MapGenerator.decorateLootRoom = function(map, room)
	for n in range(8)
		item = itemDb.getRandomItemForLevel(map.levelNumber)
		self.spawnItem(map, room, item)
	end for
end function

//MapGenerator.buildArena = function(map)
//	return arenaGenerator.build(self, map)
//end function

MapGenerator.makeEntityForLevel = function(map, levelNumber)
	if levelNumber == 0 then
		return null
	else if levelNumber < 5 then
		// The % of kobolds in the map increases as you go down.
		return math.selectItemByChance([
			[ entities.makeRat(map), (5 - levelNumber) / 5 ],
			[ entities.makeKobold(map), levelNumber / 5 ],
		])
	else if level >= 5 then
		return entities.makeKobold(map)
	end if
end function

MapGenerator.buildLevel = function(levelNumber, player)
	map = map.Map.make(levelNumber)
	if levelNumber == 0 then
		map = townGenerator.build(self, map)
	else
		map = randomDungeonGenerator.build(self, map)
	end if

	Service.fov.refresh(map.stairsUp.x, map.stairsUp.y, player.rangeOfVision, map)
	if levelNumber > 0 then
		for n in range(math.random(12, 24)) // Generate between 12 and 24 level-appropriate enemies.
			e = self.makeEntityForLevel(map, levelNumber)
			map.entities.push(e)
		end for
	end if

	return map
end function
