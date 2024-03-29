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
	
	HUD = 1
	HUD_BACK = 2

	PIXEL_0 = 3
	
	PARTICLES_0 = 4
	PARTICLES_1 = 5
	
	MAP_0 = 6
	MAP_1 = 7

	Display.hud = ui.HeadsUpDisplay.make(HUD, HUD_BACK)

	// display(PIXEL_0).install Display.pixels
	// Display.pixels = new PixelDisplay
	// Display.pixels.mode = displayMode.pixel
	Display.pixels = new PixelDisplay
	Display.pixels.install PIXEL_0
	
	Display.particles = MapDisplay.make(PARTICLES_0, PARTICLES_1)

	// display(MAP_0).mode = displayMode.off
	// display(MAP_1).mode = displayMode.off

	Display.map = MapDisplay.make(MAP_0, MAP_1)

end function

Display.clear = function()
	Display.hud.clear()
	// Display.pixels.clear()
	if display(1).mode == displayMode.off then
		Display.pixels = new PixelDisplay
		Display.pixels.install 1 //PIXEL_0
		// display(2).mode = displayMode.pixel
		// display(2).color = Color.clear.str()
		// Display.pixels = display(2)
	end if
	Display.pixels.clear Color.clear.str() // Why is this set to "off"???
	Display.particles.clear()
end function

Service = {}

// TODO: This may become redundant soon.
// The map owns the entity collection.  The rendering should happen there too.
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
	// display.color = Color.clear.str()
	// display.backColor = Color.clear.str()
	display.clear()
	// display.row = 26
	
	// display.column = 0
	// display.color = Color.white.str()
	// display.backColor = Color.black.str()

	// drawMiniMap()

	statusBar = "HP: {0}/{1} LVL: {2} XP: {3}/{4}   world: {5}".fill([player.currentHP, player.maxHP, player.level, player.xp, player.xpToNextLevel, Service.world.currentLevel])
	statusBar = statusBar + " " * (constants.UI_DISPLAY_WIDTH - statusBar.len - 10)
	
	display.print(statusBar, 0, constants.UI_DISPLAY_YMAX, Color.white.str(), Color.black.str())
	display.print(" " * constants.UI_DISPLAY_WIDTH, 0, constants.UI_DISPLAY_HEIGHT, Color.white.str(), Color.black.str())

	Service.messages.update()
end function

updateParticles = function(deltaTime, map, renderOffset)
	if Service.fountains.len > 0 then
		n = 0
		
		Display.particles.clear Color.clear.str()

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
	
	Service.world.map.clear()
	// Service.world.map.draw_v2()
	Service.world.map.draw_v1(renderOffset)
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
			

			Service.world.map.draw_v1(renderOffset)
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
