makeHealWhileResting = function()
	b = behavior.make()

	b.healWhileResting = function(entity, map)
		if entity.currentHP < entity.maxHP then
			if math.Dice.make(1, 20).roll() < (entity.numRestTurns + entity.constitutionModifier) then
				Service.makeMessageParticles(entity.position, 1, Color.green)
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

makeAttackOnCollision = function()
	b = behavior.make()

	b.onEntityCollision = function(sourceEntity, targetEntity, map)
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
			if not actions.attack(secondEntity).apply(firstEntity, map) then
				actions.attack(firstEntity).apply(secondEntity, map)
			end if
		else
			actions.attack(targetEntity).apply(sourceEntity, map)
		end if
	end function

	return b
end function

makeWander = function(changeDirectionChance = 0.5, pauseChance = 0.5)
	b = makeHealWhileResting()
	b.pauseChance = pauseChance
	b.changeDirectionChance = changeDirectionChance
	b.currentDirection = point.zero

	b.chooseNewDirection = function(entity)
		if rnd() < pauseChance then
			dx = 0
			dy = 0
		else
			dx = math.random(-1, 1)
			dy = 0
			if dx == 0 then
				dy = math.random(-1, 1)
			end if

			axis = math.random(0, 1)
			if axis == 1 then
				// Randomly choose which axis gets priority on changing.
				a = dx
				dx = dy
				dy = a
			end if
		end if

		self.currentDirection.x = dx
		self.currentDirection.y = dy
	end function

	b.shouldChooseNewDirection = function()
		return rnd() < self.changeDirectionChance
	end function

	b.wanderAround = function(entity, map)
		if self.shouldChooseNewDirection() then
			self.chooseNewDirection()
		end if

		if self.currentDirection != point.zero then
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

makeSeekAllies = function()
	b = makeWander()

	b.seekAllies_v1 = function(entity, map)
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

	b.seekAllies = function(entity, map)
		// Seeking allies is a slow process.  Can I make it faster?
		//return self.wanderAround(entity, map)
		radius = entity.rangeOfVision ^ 2

		for e in map.entities
			if e.equals(entity) or not self.isAlly(entity, e) then
				continue
			end if

			delta = entity.position.subtract(e.position)
			dist = delta.x * delta.x + delta.y * delta.y
			if dist > radius then
				continue
			end if

			// The entity can theoretically see the player.
			// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.
			delta = delta.sign()
			if delta.x != 0 and not map.blocksMovement(entity.position.x + delta.x, entity.position.y) then
				deltaX = point.make(delta.x, 0)
				newPos = entity.position.add(deltaX)
				if e.position != newPos then
					return actions.walk(deltaX)
				end if
			end if
			if delta.y != 0 and not map.blocksMovement(entity.position.x, entity.position.y + delta.y) then
				deltaY = point.make(0, delta.y)
				newPos = entity.position.add(deltaY)
				if e.position != newPos then
					return actions.walk(deltaY)
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

makeSeekPlayer = function()
	b = makeSeekAllies()

	b.act = function(entity, map)
		// The entity can theoretically see the player.
		// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.

		if entity.canSee(map.player.position) then
			action = self.moveTowards(entity, map, map.player.position)
			if action != null then
				return action
			end if
		end if
		return self.seekAllies(entity, map)
	end function
	
	return b
end function

makeUserInput = function()
	b = makeHealWhileResting()

	b.dropInventory = function(entity)
		index = ui.selectItem(entity, "Drop Inventory Item")
		if index == null then
			return null
		end if
		return actions.dropInventoryItem(index)
	end function

	b.useInventory = function(entity)
		index = ui.selectItem(entity, "Use Inventory Item")
		if index == null then
			return null
		end if
		return actions.useInventoryItem(index)
	end function

	b.takeStairsUp = function()
	end function

	b.takeStairsDown = function()
	end function

	b.examine = function(entity)
		Service.messages.reportNow("Examine in which direction?")

		k = key.get.code
		if keybindings.up.contains(k) then
			return actions.examine(entity.position.add(point.unitY))
		else if keybindings.down.contains(k) then
			return actions.examine(entity.position.add(point.unitY.negate))
		else if keybindings.left.contains(k) then
			return actions.examine(entity.position.add(point.unitX.negate))
		else if keybindings.right.contains(k) then
			return actions.examine(entity.position.add(point.unitX))
		end if

		Service.messages.reportNow("Never mind.")
		return null // Cancel the action.
	end function

	b.lookAround = function(entity, map)
		BLINK_SPEED = 300 / 1000
		lastBlinkTime = time()
		showCursor = true

		Service.messages.reportNow("Select a tile to examine it.")	

		renderOffset = SCREEN_SIZE.scale(0.5).floor.subtract(Service.world.player.position)

		drawCursor = function()
			if showCursor then
				fg = Color.red
			else
				fg = Color.blue
			end if
			bg = Color.lerp(Color.black, Color.clear, 0.5)
			ui.drawCell(Display.hud, renderOffset.x + pnt.x, renderOffset.y + pnt.y, fg, bg, "+")
		end function

		eraseCursor = function()
			ui.drawCell(Display.hud, renderOffset.x + pnt.x, renderOffset.y + pnt.y, color.clear, color.clear, " ")
		end function

		descriptionBounds = rect.make(68 - 16, 26 - 3, 16, 3)
		describe = function(map, pnt)
			if map.isVisible(pnt.x, pnt.y) then
				thing = map.getEntityAt(pnt)
				if thing == null then thing = map.tiles[pnt.y][pnt.x]
				text = thing.name
			else
				text = "hidden"
			end if

			ui.clearRect(Display.hud, descriptionBounds)

			width = math.max(16, text.len + 4)

			descriptionBounds = rect.make(68 - width, 26 - 3, width, 3)
			ui.drawWindow(Display.hud, descriptionBounds)

			ui.drawCenteredText(Display.hud, descriptionBounds.left, descriptionBounds.right, descriptionBounds.top + 1, Color.yellow, Color.black, text)
		end function

		pnt = entity.position
		describe(map, pnt)

		while true
			delta = point.zero
			if key.available then
				k = key.get.code

				if keybindings.up.contains(k) then
					delta = point.unitY
				else if keybindings.down.contains(k) then
					delta = point.unitY.negate
				else if keybindings.left.contains(k) then
					delta = point.unitX.negate
				else if keybindings.right.contains(k) then
					delta = point.unitX
				else if keybindings.select.contains(k) and map.isVisible(pnt.x, pnt.y) then
					return actions.examine(pnt)
				else if keybindings.exit.contains(k) then
					eraseCursor()
					return null // Cancel the action.
				end if
			end if

			if delta != point.zero then
				eraseCursor()
				pnt = pnt.add(delta)
				describe(map, pnt)
			end if

			if time() - lastBlinkTime > BLINK_SPEED then
				showCursor = not showCursor
				lastBlinkTime = time()
			end if
			drawCursor()
		end while
	end function

	b.act = function(entity, map)
		result = null

		while result == null
			delta = point.zero
			k = key.get.code
			if keybindings.up.contains(k) then
				result = actions.walk(point.unitY)
			else if keybindings.down.contains(k) then
				result = actions.walk(point.unitY.negate)
			else if keybindings.left.contains(k) then
				result = actions.walk(point.unitX.negate)
			else if keybindings.right.contains(k) then
				result = actions.walk(point.unitX)
			else if keybindings.inventory.contains(k) then
				result = self.useInventory(entity)
			else if keybindings.drop.contains(k) then
				result = self.dropInventory(entity)
			else if keybindings.get.contains(k) then
				result = actions.pickUpItem(point.zero)
			else if keybindings.examine.contains(k) then
				result = self.examine(entity)
			else if keybindings.look.contains(k) then
				result = self.lookAround(entity, map)
			else if keybindings.rest.contains(k) then
				result = self.healWhileResting(entity, map)
			else if keybindings.stairsDown.contains(k) and entity.position.equals(map.stairsDown) then
				// TODO: If the player is the only entity on the map, and the stairs have been seen before, allow fast travel.
				result = actions.takeStairsDown()
			else if keybindings.stairsUp.contains(k) and entity.position.equals(map.stairsUp) then
				result = actions.takeStairsUp()
			end if
		end while

		return result
	end function
	
	return b
end function
