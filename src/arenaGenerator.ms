build = function(mapgen, map)
	mapgen.drawFilledRect(map, 1, 1, map.width - 2, map.height - 2, @tiles.makeFloor)

	numPillars = 10
	for n in range(1, numPillars)
		px = math.random(0, map.width - 5) + 2
		py = math.random(0, map.height - 5) + 2
		mapgen.drawPillar(map, px, py, @tiles.makeWall)
	end for

	return map
end function