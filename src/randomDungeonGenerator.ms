build = function(mapgen, map)
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
		//mapgen.decorateRoom(map, room)
		mapgen.drawFilledRect(map, room.x, room.y, room.width, room.height, @tiles.makeFloor)
		if n > 0 then
			mapgen.drawHallway(map, rooms[n - 1], rooms[n])
		end if
	end for

	stairsUpRoomIndex = math.random(0, rooms.len - 1)
	mapgen.decorateStairsUpRoom(map, rooms[stairsUpRoomIndex])

	stairsDownRoomIndex = math.random(0, rooms.len - 1)
	while stairsDownRoomIndex == stairsUpRoomIndex
		stairsDownRoomIndex = math.random(0, rooms.len - 1)
	end while
	mapgen.decorateStairsDownRoom(map, rooms[stairsDownRoomIndex])

	lootRoomIndex = math.random(0, rooms.len - 1)
	while lootRoomIndex == stairsUpRoomIndex or lootRoomIndex == stairsDownRoomIndex
		lootRoomIndex = math.random(0, rooms.len - 1)
	end while
	mapgen.decorateLootRoom(map, rooms[lootRoomIndex])

	for room in rooms
		mapgen.decorateRoom(map, room)
	end for

	for room in rooms
		mapgen.drawDoors(map, room)
	end for

	return map
end function
