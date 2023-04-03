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

SCREEN_MAX_X = 67
SCREEN_MAX_Y = 25

// Base import.
ensureImport "features"
ensureImport "math"
ensureImport "sounds"
ensureImport "point"
ensureImport "rect"

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

ensureImport "mapgen"
ensureImport "fov"

ensureImport "keybindings"
ensureImport "settings"

Display = {}

Display.initialize = function()
	display(0).mode = displayMode.text
	Display.hud = display(0)
	Display.hud.delimiter = ""

	display(1).mode = displayMode.off
	display(1).delimiter = ""

	display(2).mode = displayMode.off
	display(2).delimiter = ""

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

	display(3).mode = displayMode.text
	Display.entities = display(3)
	Display.entities.delimiter = ""

	display(4).mode = displayMode.text
	Display.map = display(4)
	Display.map.delimiter = ""
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

	Display.entities.backColor = color.clear
	Display.entities.clear()
	
	Display.map.backColor = color.clear
	Display.map.clear()
end function

Service = {}

drawEntities = function(display, map, renderOffset)
	display.clear()
	
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
	
	display.row = 26
	//if player.position.y <= (26 / 2) then
	//	display.row = 0
	//else
	//	display.row = 26
	//end if

	display.column = 0
	display.color = color.white
	display.backColor = color.black

	statusBar = "HP: " + player.currentHP + " / " + player.maxHP + " LVL: " + player.level + " XP: " + player.xp + " / " + player.xpToNextLevel + "   world: " + Service.world.currentLevel
	statusBar = statusBar + " " * (67 - statusBar.len)
	
	display.print(statusBar)
	
	Service.messages.draw(display, true) //, player.position.y > (26 / 2))
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
	Service.world.currentLevel = 1 // Start in the dungeon.
	Service.world.player = entities.makePlayer()
	Service.world.player.enterMap = function(map, goingDown)
		if goingDown then
			self.position = map.stairsUp
		else
			self.position = map.stairsDown
		end if
		map.player = self
		map.entities.push(self)
		Service.fov.refresh(self.position.x, self.position.y, self.rangeOfVision, map)
	end function
	Service.world.player.leaveMap = function(map)
		map.player = null
		if map.entities.len > 0 then
			n = 0
			while n < map.entities.len
				if map.entities[n].isPlayer then
					map.entities.remove(n)
				else
					n += 1
				end if
			end while
		end if
	end function
	
	Service.fov = fov.FieldOfVisionCalculator.make(map.Map.width, map.Map.height)

	renderOffset = function()
		TEXT_ROWS = 26
		TEXT_COLUMNS = 68
		offsetX = floor(TEXT_COLUMNS / 2) - Service.world.player.position.x
		offsetY = floor(TEXT_ROWS / 2) - Service.world.player.position.y
		return point.make(offsetX, offsetY)
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
	drawEntities(Display.entities, Service.world.map, renderOffset)
	drawHUD(Display.hud, Service.world.player)

	deltaTime = 0
	while isRunning
		frameStart = time * 1000

		// FPS
		//text.row = 10
		//text.column = 10
		//print 1.0 / (deltaTime / 1000)

		updateParticles(deltaTime, Service.world.map, renderOffset)

		// The next step in the game occurs when the player presses a key.
		if key.available then
			n = 0
			map = Service.world.map
			while n < map.entities.len
				e = map.entities[n]
				if e.isAlive then
					action = e.act(map)
					action.apply(e, map)
				end if
				if e.isDead then
					map.entities.remove(n)
				else
					n += 1
				end if
				//n += 1
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
			drawEntities(Display.entities, Service.world.map, renderOffset)
			drawHUD(Display.hud, Service.world.player)
		end if

		deltaTime = time * 1000 - frameStart
	end while
end function

main()
