FILL_PROBABILITY = 0.4
SMOOTHING_ITERATIONS = 5
THRESHOLD_SIZE = 8

//makeFloor = @tiles.makeFloor
//makeWall = @tiles.makeWall

makeFloor = @tiles.makeGrass
makeWall = @tiles.makeMountain

// Get the points that make up a region, starting from the given position.
getRegionPoints = function(level, width, height, startX, startY, tileIndex)
	// The list of points in this region.
	points = []

	// Track whether a position has been checked.
	//print("width={0},height={1}".fill([width,height]));key.get
	mapFlags = list.init2d(height, width, false)

	// The list of tiles to check.
	queue = []

	// Prime the pump.
	queue.push(point.make(startX, startY))
	mapFlags[startY][startX] = true

	while queue.len > 0
		chunkPos = queue.pull()
		points.push(chunkPos)

		for x in range(chunkPos.x - 1, chunkPos.x + 1)
			for y in range(chunkPos.y - 1, chunkPos.y + 1)
				if math.isInRange(x, 0, width - 1) and math.isInRange(y, 0, height - 1) and ((y == chunkPos.y) or (x == chunkPos.y)) then
					if not mapFlags[y][x] then
						if level[y][x] == tileIndex then
							mapFlags[y][x] = true
							queue.push(point.make(x, y))
						end if
					end if
				end if
			end for
		end for
	end while

	return points
end function

getRegions = function(level, width, height, tileIndex)
	// This is the collection of regions we have found.
	regions = []

	// Track whether a position has been checked.
	mapFlags = list.init2d(height, width)

	for x in range(0, width - 1)
		for y in range(0, height - 1)
			if not mapFlags[y][x] then
				if level[y][x] == tileIndex then
					newRegion = getRegionPoints(level, width, height, x, y, tileIndex)
					regions.push(newRegion)

					// Mark each position in the newly-found region as checked, so we don't try putting a second region here.
					for pnt in newRegion
						mapFlags[pnt.y][pnt.x] = true
					end for
				end if
			end if
		end for
	end for

	return regions
end function

ensureMapBorder = function(level, width, height)
	for x in range(0, width - 1)
		level[0][x] = 1
		level[height - 1][x] = 1
	end for
	for y in range(0, height - 1)
		level[y][0] = 1
		level[y][width - 1] = 1
	end for
end function

// Get a list of points that make up a line between 2 points.
getLine = function(from, to)
	line = []
	
	x = from.x
	y = from.y

	dx = to.x - from.x
	dy = to.y - from.y

	inverted = false
	step = sign(dx)
	gradientStep = sign(dy)

	longest = abs(dx)
	shortest = abs(dy)

	if longest < shortest then
		inverted = true
		longest = abs(dy)
		shortest = abs(dx)

		step = sign(dy)
		gradientStep = sign(dx)
	end if

	gradientAccumulation = longest / 2
	for i in range(0, longest - 1)
		line.push(point.make(x, y))

		if inverted then
			y += step
		else
			x += step
		end if

		gradientAccumulation += shortest
		if gradientAccumulation >= longest then
			if inverted then
				x += gradientStep
			else
				y += gradientStep
			end if
			gradientAccumulation -= longest
		end if
	end for

	return line
end function

drawCircle = function(level, width, height, c, passageSize)
	passageSizeSq = passageSize * passageSize
	for x in range(-passageSize, passageSize)
		for y in range(-passageSize, passageSize)
			if x * x + y * y <= passageSizeSq then
				drawX = c.x + x
				drawY = c.y + y
				if math.isInRange(drawX, 0, width) and math.isInRange(drawY, 0, height) then
					level[y][x] = 0
				end if
			end if
		end for
	end for
end function

createPassage = function(level, width, height, region1, region2)
	start = math.randomChoice(region1)
	finish = math.randomChoice(region2)

	line = getLine(start, finish)
	for pnt in line
		drawCircle(level, width, height, pnt, 1)
	end for
end function

generateCavernLevel = function(mapgen, map)
	level = list.init2d(map.height, map.width, 0)

    // Fill the level with walls and floors randomly.
    for y in range(0, map.height - 1)
        for x in range(0, map.width - 1)
            if rnd() < FILL_PROBABILITY then level[y][x] = 1
		end for
	end for
	//ensureMapBorder(level, map.width, map.height)

    // Run the cellular automata algorithm for several iterations.
    for i in range(SMOOTHING_ITERATIONS)
        newLevel = list.init2d(map.height, map.width, 0)

        // For each tile in the level, count the number of wall tiles in a 3x3 square centered around it.
        for y in range(1, map.height - 2)
            for x in range(1, map.width - 2)
                walls = 0
                for dy in range(-1, 1)
                    for dx in range(-1, 1)
                        if level[y + dy][x + dx] == 1 then walls += 1
					end for
				end for

                if walls > 4 then
                	// If the tile is a wall and has fewer than 4 wall neighbors, turn it into a floor tile.
					newLevel[y][x] = 1
                else if walls < 4 then
                	// If the tile is a floor and has more than 5 wall neighbors, turn it into a wall tile.
                    newLevel[y][x] = 0
				else
					newLevel[y][x] = level[y][x]
				end if	
			end for
		end for

        level = newLevel
	end for

    // Fill in any isolated wall tiles by turning them into floor tiles
	//for y in range(1, map.height - 2)
	//	for x in range(1, map.width - 2)
    //        if level[y][x] == 1 then
    //            floors = 0
    //            for dy in range(-1, 1)
    //                for dx in range(-1, 1)
    //                    if level[y + dy][x + dx] == 0 then floors += 1
	//				end for
	//			end for
	//			
    //            if floors == 8 then level[y][x] = 0
	//		end if
	//	end for
	//end for

	// Check the size of all wall regions.  Replace them with floors if they're too small.
	wallRegions = getRegions(level, map.width, map.height, 1)
	for region in wallRegions
		if region.len < THRESHOLD_SIZE then
			for pnt in region
				level[pnt.y][pnt.x] = 0
			end for
		end if
	end for

	// Check the size of all floor regions.  Replace them with walls if they're too small.
	floorRegions = getRegions(level, map.width, map.height, 0)
	for region in floorRegions
		if region.len < THRESHOLD_SIZE then
			for pnt in region
				level[pnt.y][pnt.x] = 1
			end for
		end if
	end for
	
	// Regenerate as the floor regions may have changed.
	floorRegions = getRegions(level, map.width, map.height, 0)
	for n in range(1, floorRegions.len - 1)
		createPassage(level, map.width, map.height, floorRegions[n - 1], floorRegions[n])
	end for	

    // Add some random noise to the level to make it look more natural.
	// TODO: Use the tree tile here.
	// TODO: Need to create a tree tile.
    //for y in range(0, map.height - 1)
    //    for x in range(0, map.width - 1)
    //        if level[y][x] == 0 and rnd() < 0.1 then
    //            level[y][x] = 2
    //        //else if level[y][x] == 1 and rnd() < 0.05 then
    //        //    level[y][x] = 0
	//		end if
	//	end for
	//end for

	ensureMapBorder(level, map.width, map.height)

    // Load the map with the tile data.
    for y in range(0, map.height - 1)
        for x in range(0, map.width - 1)
			t = level[y][x]
			if t == 0 then
				map.tiles[y][x] = makeFloor()
            else if t == 1 or t == 2 then
				map.tiles[y][x] = makeWall()
			end if
		end for
	end for

	// Place the stairs down.
	pnt = findSpawnPoint(map)
	map.tiles[pnt.y][pnt.x] = tiles.makeStairsDown()
	map.stairsDown = pnt

	// foundSpot = false
	// while not foundSpot
	// 	x = math.random(0, map.width - 1)
	// 	y = math.random(0, map.height - 2)
	// 	if not map.blocksMovement(x, y) then
	// 		map.tiles[y][x] = tiles.makeStairsDown()
	// 		map.stairsDown = point.make(x, y)
	// 		foundSpot = true
	// 	end if
	// end while

	// Place the player spawn near the stairs down.
	pnt = findSpawnPointInRadius(map, map.stairsDown, 5)
	map.stairsUp = pnt

	// foundSpot = false
	// while not foundSpot
	// 	// Put the spawn point near the stairs down.
	// 	x = math.random(map.stairsDown.x - 5, map.stairsDown.x + 5)
	// 	y = math.random(map.stairsDown.y - 5, map.stairsDown.y + 5)
	// 	if not map.blocksMovement(x, y) and not pnt.equals(map.stairsDown) then
	// 		// We need the stairsUp point for spawning, but there is no level < 0.
	// 		//map.tiles[y][x] = tiles.makeStairsUp()
	// 		map.stairsUp = point.make(x, y)
	// 		foundSpot = true
	// 	end if
	// end while

	// Place a sign post.
	pnt = findSpawnPointInRadius(map, map.stairsDown, 5)
	e = entities.makeSign(map, pnt, "Under construction, please come back later!")
	map.entities.push(e)

	// foundSpot = false
	// while not foundSpot
	// 	// Put the spawn point near the stairs down.
	// 	x = math.random(map.stairsDown.x - 5, map.stairsDown.x + 5)
	// 	y = math.random(map.stairsDown.y - 5, map.stairsDown.y + 5)
	// 	pnt = point.make(x, y)
	// 	if not map.blocksMovement(x, y) and not map.isEntityAt(pnt) and not pnt.equals(map.stairsDown) then
	// 		e = entities.makeSign(map, pnt, "Under construction, please come back later!")
	// 		map.entities.push(e)
	// 		foundSpot = true
	// 	end if
	// end while

	// pnt = findSpawnPointInRadius(map, map.stairsDown, 20)
	// e = entities.makeSimpleVillager(map, pnt, "Welcome to Village!")
	// map.entities.push(e)

	for n in range(10)
		pnt = findSpawnPointInRadius(map, map.stairsDown, 20)
		e = entities.makeSimpleVillager(map, pnt)
		map.entities.push(e)
	end for

	return map
end function

findSpawnPoint = function(map)
	while true
		sx = math.random(0, map.width - 1)
		sy = math.random(0, map.height - 1)
		if not map.blocksMovement(sx, sy) then
			return point.make(sx, sy)
		end if
	end while
end function

findSpawnPointInRadius = function(map, pnt, radius)
	while true
		// Put the spawn point near the stairs down.
		sx = math.random(pnt.x - radius, pnt.x + radius)
		sy = math.random(pnt.y - radius, pnt.y + radius)
		sp = point.make(sx, sy)
		if not map.blocksMovement(sx, sy) and not map.isEntityAt(sp) and not sp.equals(map.stairsDown) then
			return sp
		end if
	end while
end function

build = function(mapgen, map)
	return generateCavernLevel(mapgen, map)
end function