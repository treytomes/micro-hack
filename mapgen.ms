import "tile"
import "map"

MapGenerator = {}

MapGenerator.fillRect = function(map, x, y, width, height, tile)
	for y0 in range(y, height)
		for x0 in range(x, width)
			map.tiles[y0][x0] = tile()
		end for
	end for
end function

MapGenerator.pillar = function(map, x, y, tile)
	map.tiles[y - 1][x] = tile()
	map.tiles[y][x] = tile()
	map.tiles[y + 1][x] = tile()
	map.tiles[y][x - 1] = tile()
	map.tiles[y][x + 1] = tile()
end function

MapGenerator.sampleLevel = function()
	map = map.Map.make
	self.fillRect(map, 1, 1, map.width - 2, map.height - 2, @tile.Tile.makeFloor)

	numPillars = 10
	for n in range(1, numPillars)
		px = floor(rnd() * (map.width - 4)) + 2
		py = floor(rnd() * (map.height - 4)) + 2
		self.pillar(map, px, py, @tile.Tile.makeWall)
	end for

	return map
end function
