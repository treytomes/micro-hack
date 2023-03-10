import "sounds"
import "point"
import "entity"
import "actions"


Tile = {}
Tile.blocksMovement = false
Tile.blocksVision = false
Tile.char = " "
Tile.backgroundColor = color.black
Tile.foregroundColor = color.gray

Tile.makeFloor = function()
	t = new Tile
	t.char = "."
	return t
end function

Tile.makeWall = function()
	t = new Tile
	t.blocksMovement = true
	t.blocksVision = true
	t.char = "#"
	t.foregroundColor = color.silver
	return t
end function

Tile.draw = function(x, y)
	text.setCellColor x, y, self.foregroundColor
	text.setCellBackColor x, y, self.backgroundColor
	text.setCell x, y, self.char
end function


Map = {}
Map.height = 26
Map.width = 68
Map.tiles = []

Map.make = function()
	m = new Map
	for y in range(m.height)
		row = []
		for x in range(m.width)
			row.push Tile.makeWall
		end for
		m.tiles.push row
	end for
	return m
end function

Map.blocksMovement = function(x, y)
	return self.tiles[y][x].blocksMovement
end function

Map.blocksVision = function(x, y)
	return self.tiles[y][x].blocksVision
end function

Map.drawTile = function(x, y)
	self.tiles[y][x].draw x, y
end function

Map.draw = function()
	for y in range(self.height)
		for x in range(self.width)
			self.drawTile x, y
		end for
	end for
end function


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
	map = Map.make
	self.fillRect(map, 1, 1, map.width - 2, map.height - 2, @Tile.makeFloor)

	numPillars = 10
	for n in range(1, numPillars)
		px = floor(rnd() * (map.width - 4)) + 2
		py = floor(rnd() * (map.height - 4)) + 2
		self.pillar(map, px, py, @Tile.makeWall)
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
	k = key.get.upper
	if k == "W" then
		action = actions.EntityAction.walk(0, 1)
	else if k == "S" then
		action = actions.EntityAction.walk(0, -1)
	else if k == "A" then
		action = actions.EntityAction.walk(-1, 0)
	else if k == "D" then
		action = actions.EntityAction.walk(1, 0)
	end if
	
	action.apply(player, map)
end while
