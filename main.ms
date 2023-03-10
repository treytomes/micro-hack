import "sounds"
import "point"
import "entity"
import "actions"
import "tile"
import "map"

Keys = { "left": 17,
		 "right": 18,
		 "up": 19,
		 "down": 20 }

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


sounds.Sounds.initialize()

isRunning = true
map = MapGenerator.sampleLevel

// Find a spawn point.
foundSpawnPoint = false
px = 0
py = 0
while not foundSpawnPoint
	px = floor(rnd() * map.width)
	py = floor(rnd() * map.height)
	if not map.blocksMovement(px, py) then
		foundSpawnPoint = true
	end if
end while
player = entity.Entity.make(px, py)

text.clear
map.draw
player.draw

while isRunning
	action = actions.EntityAction.wait

	delta = point.Point.make(0, 0)
	k = key.get.code
	if k == Keys.up then
		action = actions.EntityAction.walk(0, 1)
	else if k == Keys.down then
		action = actions.EntityAction.walk(0, -1)
	else if k == Keys.left then
		action = actions.EntityAction.walk(-1, 0)
	else if k == Keys.right then
		action = actions.EntityAction.walk(1, 0)
	end if
	
	action.apply(player, map)
end while
