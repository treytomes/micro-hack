import "actions"
import "point"
import "math"
import "rect"

Behavior = {}
Behavior.willAttackSameRace = false

Behavior.moveTowards = function(entity, map, position)
	deltaX = sign(position.x - entity.position.x)
	deltaY = sign(position.y - entity.position.y)

	if deltaX ^ 2 + deltaY ^ 2 <= entity.rangeOfVision ^ 2 then
		// The entity can theoretically see the player.
		// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.

		if deltaX != 0 and not map.blocksMovement(entity.position.x + deltaX, entity.position.y) then
			return actions.walk(point.make(deltaX, 0))
		else if deltaY != 0 and not map.blocksMovement(entity.position.x, entity.position.y + deltaY) then
			return actions.walk(point.make(0, deltaY))
		end if
	end if

	return null
end function

Behavior.findNearbyEntities = function(entity, map)
	found = []
	radius = entity.rangeOfVision ^ 2

	for e in map.entities
		if e == entity then
			continue
		end if
		if e == null then
			continue
		end if

		deltaX = entity.position.x - e.position.x
		deltaY = entity.position.y - e.position.y
		dist = deltaX ^ 2 + deltaY ^ 2
		if dist <= radius then
			found.push(e)
		end if
	end for
	return found
end function

Behavior.isAlly = function(source, target)
	return source.race == target.race and not self.willAttackSameRace
end function

Behavior.act = function()
	return actions.wait()
end function

Behavior.onEntityCollision = function(sourceEntity, targetEntity)
end function

Behavior.makeHealWhileResting = function()
	b = new Behavior

	b.healWhileResting = function(entity, map)
		if entity.currentHP < entity.maxHP then
			if math.Dice.make(1, 20).roll() < (entity.numRestTurns + entity.constitutionModifier) then
				Service.makeMessageParticles(entity.position.x, entity.position.y, 1, color.green)
				entity.modifyHP(1)
			end if
		end if
		return actions.wait()
	end function

	b.act = function(entity, map)
		return self.healWhileResting(entity, map)
	end function

	return b
end function

Behavior.makeAttackOnCollision = function()
	b = new Behavior

	b.onEntityCollision = function(sourceEntity, targetEntity)
		// Assume every entity has the fighter class.
		// Assume melee attacks.
		// Assume every entity is carrying a basic 1-handed short sword with damage of 1d8.

		if self.isAlly(sourceEntity, targetEntity) then
			// Don't attack allies.
			return
		end if
		
		if features.ALWAYS_COUNTER_ATTACK then
			// 1. Calculate initiative order.
			sourceInitiative = math.Dice.make(1, 20, sourceEntity.dexterityModifier).roll()
			targetInitiative = math.Dice.make(1, 20, targetEntity.dexterityModifier).roll()

			// 2. Highest initiative goes first.
			firstEntity = sourceEntity
			secondEntity = targetEntity
			if targetInitiative > sourceInitiative then
				firstEntity = targetEntity
				secondEntity = sourceEntity
			end if

			// 3. Attack roll.
			if not self.attack(firstEntity, secondEntity) then
				actions.attack(secondEntity).apply(firstEntity)
			end if
		else
			actions.attack(targetEntity).apply(sourceEntity)
		end if
	end function

	return b
end function

Behavior.makeRandomWalk = function()
	b = Behavior.makeHealWhileResting
	b.currentDirection = point.zero

	b.chooseNewDirection = function(entity)
		dx = math.random(-1, 1)
		dy = 0
		if dx == 0 then
			dy = math.random(-1, 1)
		end if
		self.currentDirection.x = dx
		self.currentDirection.y = dy
	end function

	b.shouldChooseNewDirection = function()
		return rnd() > 0.5
	end function

	b.wanderAround = function(entity, map)
		if self.shouldChooseNewDirection() then
			self.chooseNewDirection()
		end if

		if self.currentDirection.x != 0 or self.currentDirection.y != 0 then
			return actions.walk(self.currentDirection) 
		else
			return self.healWhileResting(entity, map)
		end if
	end function

	b.act = function(entity, map)
		return b.wanderAround(entity, map)
	end function

	return b
end function

Behavior.makeSeekAllies = function()
	b = Behavior.makeRandomWalk()

	b.seekAllies = function(entity, map)
		allies = self.findNearbyEntities(entity, map)
		if allies.len == 0 then
			return self.wanderAround(entity, map)
		end if

		for ally in allies
			if self.isAlly(entity, ally) then
				action = self.moveTowards(entity, map, ally.position)
				if action != null then
					return action
				end if
			end if
		end for

		return self.wanderAround(entity, map)
	end function

	b.act = function(entity, map)
		return self.seekAllies(entity, map)
	end function

	return b
end function

Behavior.makeSeekPlayer = function()
	b = Behavior.makeSeekAllies()

	b.act = function(entity, map)
		// The entity can theoretically see the player.
		// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.

		action = self.moveTowards(entity, map, map.player.position)
		if action != null then
			return action
		end if
		return self.seekAllies(entity, map)
	end function
	
	return b
end function

Behavior.makeUserInput = function()
	b = Behavior.makeHealWhileResting

	b.drawInventory = function(entity)
		windowBounds = rect.make(4, 4, 68 - 4 * 2, 26 - 4 * 2)
		ui.drawWindow(Display.hud, windowBounds, "Inventory")

		Display.hud.backColor = color.black
		Display.hud.color = color.gray
		n = 1
		y = windowBounds.bottom - 1

		for n in range(0, entity.inventory.len - 1)
			item = entity.inventory[n]
			isEquipped = entity.weapon == item

			Display.hud.row = y
			Display.hud.column = windowBounds.left + 1
			Display.hud.print((n + 1) + ". " + item.str())
			if isEquipped then
				Display.hud.print(" [E]")
			end if

			y -= 1
			n += 1
		end for
	end function

	b.eraseInventory = function()
		windowBounds = rect.make(4, 4, 68 - 4 * 2, 26 - 4 * 2)
		ui.clearRect(Display.hud, windowBounds, " ", color.clear, color.clear)
	end function

	b.useInventory = function(entity)
		self.drawInventory(entity)

		k = key.get.code
		inventoryIndex = k - 48

		result = null
		if inventoryIndex >= 0 and inventoryIndex < entity.inventory.len then
			result = actions.useInventoryItem(inventoryIndex)
		end if

		self.eraseInventory()
		return result
	end function

	b.act = function(entity, map)
		result = null

		while result == null
			delta = point.zero
			k = key.get.code
			if k == keybindings.up then
				result = actions.walk(point.unitY)
			else if k == keybindings.down then
				result = actions.walk(point.unitY.negate)
			else if k == keybindings.left then
				result = actions.walk(point.unitX.negate)
			else if k == keybindings.right then
				result = actions.walk(point.unitX)
			else if k == keybindings.inventory then
				result = b.useInventory(entity)
			else if k == keybindings.rest then
				result = self.healWhileResting(entity, map)
			end if
		end while

		return result
	end function
	
	return b
end function
