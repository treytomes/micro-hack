import "tile"
import "map"
import "math"
import "rect"

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

MapGenerator.drawHallway = function(map, room0, room1, tile)
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

MapGenerator.buildArena = function()
	map = map.Map.make()
	self.drawFilledRect(map, 1, 1, map.width - 2, map.height - 2, @tile.Tile.makeFloor)

	numPillars = 10
	for n in range(1, numPillars)
		px = math.random(0, map.width - 4) + 2
		py = math.random(0, map.height - 2) + 2
		self.drawPillar(map, px, py, @tile.Tile.makeWall)
	end for

	return map
end function

MapGenerator.buildRandomDungeon = function()
	map = map.Map.make()

	numRooms = math.random(5, 10)
	minRoomSize = 5
	maxRoomSize = 10
	rooms = []
	for n in range(0, numRooms - 1)
		roomWidth = math.random(minRoomSize, maxRoomSize)
		roomHeight = math.random(minRoomSize, maxRoomSize)

		roomX = math.random(1, map.width - roomWidth - 2)
		roomY = math.random(1, map.height - roomHeight - 2)

		room = rect.make(roomX, roomY, roomWidth, roomHeight)
		rooms.push(room)
		self.drawFilledRect(map, room.x, room.y, room.width, room.height, @tile.Tile.makeFloor)
		if n > 0 then
			self.drawHallway(map, rooms[n - 1], rooms[n], @tile.Tile.makeFloor)
		end if
	end for

	return map
end function
