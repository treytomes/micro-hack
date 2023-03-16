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
import "particles"
import "fov"
import "features"

Display = {}
Service = {}

drawEntities = function(display, map, renderOffset)
	display.clear()
	for e in map.entities
		if map.isVisible(e.position.x, e.position.y) then
			e.draw(display, renderOffset)
		end if
	end for
end function

drawHUD = function(display, player)
	display.color = color.clear
	display.backColor = color.clear
	display.clear()
	display.row = 26
	if player.position.y <= (26 / 2) then
		display.row = 0
	else
		display.row = 26
	end if
	display.column = 0
	display.color = color.white
	display.backColor = color.black

	statusBar = "HP: " + player.currentHP + " / " + player.maxHP + " LVL: " + player.level + " XP: " + player.xp + " / " + player.xpToNextLevel

	statusBar = statusBar + " " * (67 - statusBar.len)
	display.print(statusBar)
	
	Service.messages.draw(display, player.position.y > (26 / 2))
	Service.messages.update()
end function

generateDisplays = function()
	display(0).mode = displayMode.text
	Display.hud = display(0)
	Display.hud.delimiter = ""

	display(1).mode = displayMode.text
	Display.particles = display(1)
	Display.particles.delimiter = ""

	display(2).mode = displayMode.text
	Display.entities = display(2)
	Display.entities.delimiter = ""

	display(3).mode = displayMode.text
	Display.map = display(3)
	Display.map.delimiter = ""
end function

updateParticles = function(deltaTime, map, renderOffset)
	if Service.fountains.len > 0 then
		//Display.particles.backColor = color.clear
		//Display.particles.clear()
		
		n = 0
		while n < Service.fountains.len
			f = Service.fountains[n]
			f.draw(Display.particles, deltaTime, map, renderOffset)
			if not f.isAlive then
				Service.fountains.remove(n)
			else
				n += 1
			end if
		end while
	end if
end function

main = function()
	sounds.Sounds.initialize()

	isRunning = true
	//map = mapgen.MapGenerator.buildArena()
	map = mapgen.MapGenerator.buildRandomDungeon()

	player = entity.Entity.makePlayer(map)
	map.player = player

	renderOffset = function()
		TEXT_ROWS = 26
		TEXT_COLUMNS = 68
		offsetX = floor(TEXT_COLUMNS / 2) - player.position.x
		offsetY = floor(TEXT_ROWS / 2) - player.position.y
		return point.make(offsetX, offsetY)
	end function

	map.entities.push(player)
	map.entities.push(entity.Entity.makeKobold(map))
	map.entities.push(entity.Entity.makeKobold(map))
	map.entities.push(entity.Entity.makeKobold(map))
	map.entities.push(entity.Entity.makeKobold(map))
	map.entities.push(entity.Entity.makeKobold(map))

	Service.messages = hud.MessageLog.make()
	Service.fov = fov.FieldOfVisionCalculator.make(map.width, map.height)

	Service.fov.refresh(player.position.x, player.position.y, player.rangeOfVision, map)
	
	Service.fountains = []
	Service.makeDamageParticles = function(x, y)
		Service.fountains.push(particles.ParticleFountain.makeDamageParticles(x, y))
	end function

	Service.makeMessageParticles = function(x, y, message, foregroundColor)
		Service.fountains.push(particles.ParticleFountain.makeMessageParticles(x, y, message, foregroundColor))
	end function

	text.clear()

	generateDisplays()

	map.clearScreen(Display.map)
	map.draw(Display.map, player, renderOffset)
	drawEntities(Display.entities, map, renderOffset)
	drawHUD(Display.hud, player)

	deltaTime = 0
	while isRunning
		frameStart = time * 1000

		// FPS
		//text.row = 10
		//text.column = 10
		//print 1.0 / (deltaTime / 1000)

		updateParticles(deltaTime, map, renderOffset)

		// The next step in the game occurs when the player presses a key.
		if key.available then
			n = 0
			while n < map.entities.len
				e = map.entities[n]
				if e != null then
					if e.currentHP > 0 then
						action = e.act(map)
						action.apply(e, map)
					else
						map.entities[n] = null
					end if
				end if
				n += 1
			end while

			n = 0
			while n < map.entities.len
				if map.entities[n] == null or map.entities[n].currentHP <= 0 then
					map.entities.remove(n)
				else
					n += 1
				end if
			end while

			if player.currentHP <= 0 then
				Service.messages.report("YOU ARE DEAD!")
			end if
			
			map.draw(Display.map, player, renderOffset)
			drawEntities(Display.entities, map, renderOffset)
			drawHUD(Display.hud, player)
		end if

		deltaTime = time * 1000 - frameStart
	end while
end function

main()
