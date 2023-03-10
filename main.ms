import "sounds"
import "point"
import "entity"
import "actions"
import "tile"
import "map"
import "mapgen"
import "behaviors"

entity.Entity.makePlayer = function(map)
	spawnPoint = map.findSpawnPoint()
	player = entity.Entity.make(spawnPoint)
	player.isPlayer = true
	player.behaviors.push(behaviors.Behavior.makeUserInput())
	return player
end function

entity.Entity.makeKobold = function(map)
	spawnPoint = map.findSpawnPoint()
	kobold = entity.Entity.make(spawnPoint)
	kobold.tile.foregroundColor = color.orange
	kobold.tile.char = "k";
	kobold.behaviors.push(behaviors.Behavior.makeRandomWalk())
	return kobold
end function

sounds.Sounds.initialize()

isRunning = true
map = mapgen.MapGenerator.sampleLevel()

player = entity.Entity.makePlayer(map)
map.entities.push(player)
map.entities.push(entity.Entity.makeKobold(map))
map.entities.push(entity.Entity.makeKobold(map))
map.entities.push(entity.Entity.makeKobold(map))
map.entities.push(entity.Entity.makeKobold(map))
map.entities.push(entity.Entity.makeKobold(map))

text.clear()
map.draw()

for e in map.entities
	e.draw()
end for

while isRunning
	for e in map.entities
		action = e.act()
		action.apply(e, map)
	end for
end while
