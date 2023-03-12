import "tc"
import "sounds"
import "point"
import "actions"
import "tile"
import "map"
import "mapgen"
import "behaviors"
import "math"
import "hud"
import "weapons"
import "races"
import "classes"
import "entity"

entity.Entity.makePlayer = function(map)
	spawnPoint = map.findSpawnPoint()
	e = entity.Entity.make(spawnPoint)
	e.isPlayer = true

	e.race = races.RaceDescriptions.human
	e.name = "player" //e.race.name
	e.class = classes.ClassDescriptions.fighter
	e.weapon = weapons.WeaponDescriptions.shortsword

	e.level = 1
	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = e.class.rollForConstitution()
	e.maxHP = e.class.rollForHP() + e.constitutionModifier
	e.currentHP = e.maxHP

	e.behaviors.push(behaviors.Behavior.makeUserInput())
	return e
end function

entity.Entity.makeKobold = function(map)
	spawnPoint = map.findSpawnPoint()
	e = entity.Entity.make(spawnPoint)
	e.tile.foregroundColor = color.orange
	e.tile.char = "k";

	e.race = races.RaceDescriptions.kobold
	e.name = e.race.name
	e.class = classes.ClassDescriptions.fighter
	e.weapon = weapons.WeaponDescriptions.unarmed

	e.level = 1
	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = 7
	e.maxHP = e.class.rollForHP() + e.constitutionModifier
	e.currentHP = e.maxHP

	e.behaviors.push(behaviors.Behavior.makeRandomWalk())
	return e
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

display(0).mode = displayMode.text
hudText = display(0)
hudText.delimiter = ""
hud.messages = hud.MessageLog.make()

display(1).mode = displayMode.text
entityText = display(1)
entityText.delimiter = ""

while isRunning
	map.draw()

	entityText.clear()
	for e in map.entities
		e.draw(entityText)
	end for

	// Draw the HUD.
	hudText.color = color.clear
	hudText.backColor = color.clear
	hudText.clear()
	hudText.row = 26
	if player.position.y <= (26 / 2) then
		hudText.row = 0
	else
		hudText.row = 26
	end if
	hudText.column = 0
	hudText.color = color.white
	hudText.backColor = color.black
	hudText.print "HP: " + player.currentHP + " / " + player.maxHP
	
	hud.messages.draw(player.position.y > (26 / 2))

	for n in range(0, map.entities.len - 1)
		e = map.entities[n]
		if e != null then
			if e.currentHP > 0 then
				action = e.act(map)
				action.apply(e, map)
			else
				map.entities[n] = null
			end if
		end if
	end for

	n = 0
	while n < map.entities.len
		if map.entities[n] == null then
			map.entities.remove(n)
		else
			n += 1
		end if
	end while

	if player.currentHP <= 0 then
		hud.messages.report("YOU ARE DEAD!")
	end if
end while
