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
ensureImport "constants"
ensureImport "math"
ensureImport "sounds"
ensureImport "point"
ensureImport "rect"

SCREEN_MAX_X = constants.TILE_DISPLAY_WIDTH - 1
SCREEN_MAX_Y = constants.TILE_DISPLAY_HEIGHT - 1
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
ensureImport "phrases"

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
	MapDisplay = require("MapDisplay")
	
	// HUD = 0
	// HUD_BACK = 1
	// PARTICLES_0 = 2
	// PARTICLES_1 = 3
	// MAP_0 = 4
	// MAP_1 = 5

	activate = function(n)
		display(n).mode = displayMode.text
		display(n).delimiter = ""
		return display(n)
	end function

	deactivate = function(n)
		display(n).mode = displayMode.off
		return display(n)
	end function

	Display.hud = ui.HeadsUpDisplay.make(0, 1)
	
	Display.particles = MapDisplay.make(2, 3)

	Display.map = MapDisplay.make(4, 5)
end function

Display.clear = function()
	Display.hud.clear()
	Display.particles.clear()
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
	// display.color = color.clear
	// display.backColor = color.clear
	display.clear()
	// display.row = 26
	
	// display.column = 0
	// display.color = color.white
	// display.backColor = color.black

	statusBar = "HP: {0}/{1} LVL: {2} XP: {3}/{4}   world: {5}".fill([player.currentHP, player.maxHP, player.level, player.xp, player.xpToNextLevel, Service.world.currentLevel])
	statusBar = statusBar + " " * (constants.UI_DISPLAY_WIDTH - statusBar.len)
	
	display.print(statusBar, 0, constants.UI_DISPLAY_YMAX, color.white, color.black)
	display.print(" " * constants.UI_DISPLAY_WIDTH, 0, constants.UI_DISPLAY_HEIGHT, color.white, color.black)

	Service.messages.update()
end function

updateParticles = function(deltaTime, map, renderOffset)
	if Service.fountains.len > 0 then
		n = 0
		
		Display.particles.clear color.clear

		while n < Service.fountains.len
			f = Service.fountains[n]
			f.draw(Display.particles, deltaTime, map, renderOffset)
			if not f.isAlive then
				Service.fountains.remove(n)
			else
				n += 1
			end if
		end while

		Display.particles.flip
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
	
	Service.world.map.clear(Display.map)
	// Service.world.map.draw_v2(Display.map)
	Service.world.map.draw_v1(Display.map, Service.world.player, renderOffset)
	drawEntities(Display.map, Service.world.map, renderOffset)
	Display.map.flip

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
			

			Service.world.map.draw_v1(Display.map, Service.world.player, renderOffset)
			drawEntities(Display.map, Service.world.map, renderOffset)
			Display.map.flip

			drawHUD(Display.hud, Service.world.player)
		end if

		deltaTime = time * 1000 - frameStart
	end while
end function

main()
clear
print "All done!"
