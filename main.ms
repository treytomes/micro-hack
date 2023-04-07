env.importPaths = [
	"/sys/lib",
	"./src",
	"./src/behaviors",
	"./src/config",
	"./src/factories",
	"./src/ui",
	"./src/util",
]

// Library imports.
import "listUtil"
import "coreUtil"
import "objectUtil"
import "colorUtil"
import "stringUtil"

// "features" must be imported first.  "settings" must be imported last.

// Base import.
ensureImport "features"
ensureImport "math"
ensureImport "sounds"
ensureImport "point"
ensureImport "rect"

SCREEN_MAX_X = 67
SCREEN_MAX_Y = 25
SCREEN_SIZE = point.make(SCREEN_MAX_X, SCREEN_MAX_Y)

// "Graphics"
ensureImport "ui"
ensureImport "particles"

ensureImport "actions"
ensureImport "tile"
ensureImport "map"
ensureImport "behaviors"
ensureImport "hud"

ensureImport "behavior"
ensureImport "class"
ensureImport "entity"
ensureImport "item"
ensureImport "healingPotionItem" // depends on item
ensureImport "race"
ensureImport "weapon" // depends on item
ensureImport "shield" // depends on weapon
ensureImport "armor"
ensureImport "particle"
ensureImport "particleFountain"
ensureImport "world"
ensureImport "itemDb"
ensureImport "itemStack"
ensureImport "inventory"

// Factories
ensureImport "armors"
ensureImport "classes"
ensureImport "entities"
ensureImport "items"
ensureImport "races"
ensureImport "shields"
ensureImport "tiles"
ensureImport "weapons"
ensureImport "names"

ensureImport "arenaGenerator"
ensureImport "randomDungeonGenerator"
ensureImport "cavernGenerator"
ensureImport "townGenerator"
ensureImport "mapgen"
ensureImport "fov"

ensureImport "keybindings"
ensureImport "settings"

Display = {}

Display.initialize = function()
	activate = function(n)
		display(n).mode = displayMode.text
		display(n).delimiter = ""
		return display(n)
	end function

	deactivate = function(n)
		display(n).mode = displayMode.off
		return display(n)
	end function

	Display.hud = activate(0)
	
	Display.particles = activate(1)
	deactivate(1)
	activate(2)

	Display.particles = display(1)
	Display.flipParticles = function()
		if display(1).mode == displayMode.off then
			display(1).mode = displayMode.text
			display(2).mode = displayMode.text
			Display.particles = display(2)
			display(2).mode = displayMode.off
		else
			display(1).mode = displayMode.text
			display(2).mode = displayMode.text
			Display.particles = display(1)
			display(1).mode = displayMode.off
		end if
	end function

	Display.map = activate(3)
	deactivate(3)
	activate(4)

	Display.flipMap = function()
		if display(3).mode == displayMode.off then
			activate(3)
			Display.map = activate(4)
			deactivate(4)
		else
			activate(4)
			Display.map = activate(3)
			deactivate(3)
		end if
	end function
end function

Display.clear = function()
	Display.hud.backColor = color.clear
	Display.hud.clear()
	Display.flipParticles()
	
	Display.particles.backColor = color.clear
	Display.particles.clear()
	Display.flipParticles()
	Display.particles.backColor = color.clear
	Display.particles.clear()
	Display.flipParticles()
	
	//Display.map.backColor = color.clear
	//Display.map.clear()
	//Display.flipMap()
	//Display.map.backColor = color.clear
	//Display.map.clear()
	//Display.flipMap()
end function

Service = {}

// TODO: This may become redundant soon.
drawEntities = function(display, map, renderOffset)
	// First draw entities that you can step on.
	for e in map.entities
		if map.isVisible(e.position.x, e.position.y) and not e.tile.blocksMovement then
			e.draw(display, renderOffset)
		end if
	end for
	
	// Then draw everything else.
	for e in map.entities
		if map.isVisible(e.position.x, e.position.y) and e.tile.blocksMovement then
			e.draw(display, renderOffset)
		end if
	end for
end function

drawHUD = function(display, player)
	display.color = color.clear
	display.backColor = color.clear
	display.clear()
	display.row = 26
	
	display.column = 0
	display.color = color.white
	display.backColor = color.black

	statusBar = "HP: {0} / {1} LVL: {2} XP: {3} / {4}   world: {5}".fill([player.currentHP, player.maxHP, player.level, player.xp, player.xpToNextLevel, Service.world.currentLevel])
	statusBar = statusBar + " " * (67 - statusBar.len)
	
	display.print(statusBar)
	
	Service.messages.update()
end function

updateParticles = function(deltaTime, map, renderOffset)
	if Service.fountains.len > 0 then
		n = 0
		
		Display.particles.backColor = color.clear
		Display.particles.clear()

		while n < Service.fountains.len
			f = Service.fountains[n]
			f.draw(Display.particles, deltaTime, map, renderOffset)
			if not f.isAlive then
				Service.fountains.remove(n)
			else
				n += 1
			end if
		end while

		Display.flipParticles()
	end if
end function

main = function()
	Display.initialize()
	isRunning = true

	Service.world = new world.World
	Service.world.currentLevel = 0
	Service.world.player = entities.makePlayer()
		
	Service.fov = fov.FieldOfVisionCalculator.make(map.Map.width, map.Map.height)

	renderOffset = function()
		return SCREEN_SIZE.scale(0.5).floor.subtract(Service.world.player.position)
	end function

	// For rendering purposes, it makes sense for the player to be last.
	Service.world.player.enterMap(Service.world.map, true)

	Service.messages = hud.MessageLog.make()
	
	Service.fountains = []
	Service.makeDeathParticles = function(pnt)
		Service.fountains.push(particles.makeDeathParticles(pnt))
	end function
	Service.makeLevelUpParticles = function(pnt)
		Service.fountains.push(particles.makeLevelUpParticles(pnt))
	end function
	Service.makeMessageParticles = function(pnt, message, foregroundColor)
		Service.fountains.push(particles.makeMessageParticles(pnt, message, foregroundColor))
	end function
	
	Display.clear()
	
	Service.world.map.clearScreen(Display.map)
	Service.world.map.draw(Display.map, Service.world.player, renderOffset)
	drawEntities(Display.map, Service.world.map, renderOffset)
	Display.flipMap()

	drawHUD(Display.hud, Service.world.player)

	deltaTime = 0
	while isRunning
		frameStart = time * 1000

		updateParticles(deltaTime, Service.world.map, renderOffset)

		// The next step in the game occurs when the player presses a key.
		if key.available then
			map = Service.world.map

			n = 0
			while n < map.entities.len
				e = map.entities[n]
				if e.isAlive then
					e.act(map).apply(e, map)
				end if
				if e.isDead then
					map.entities.remove(n)
				else
					n += 1
				end if
			end while

			// Check for dead entities after everyone has had a chance to act.
			n = 0
			while n < map.entities.len
				e = map.entities[n]
				if e.isDead then
					map.entities.remove(n)
				else
					n += 1
				end if
			end while

			if Service.world.player.isDead then
				Service.messages.report("YOU ARE DEAD!")
			end if
			
			Service.world.map.draw(Display.map, Service.world.player, renderOffset)
			drawEntities(Display.map, Service.world.map, renderOffset)
			
			Display.flipMap()
			drawHUD(Display.hud, Service.world.player)
		end if

		deltaTime = time * 1000 - frameStart
	end while
end function

main()
