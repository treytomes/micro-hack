makeHealWhileResting = function()
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

makeAttackOnCollision = function()
	b = new Behavior

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

makeWander = function()
	b = makeHealWhileResting()
	b.currentDirection = point.zero

	b.chooseNewDirection = function(entity)
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
	b.firstDisplayIndex = 0
	b.selectedInventoryIndex = 0

	b.windowBounds = function()
		return rect.make(4, 4, 68 - 4 * 2, 26 - 4 * 2)
	end function

	b.maxDisplayLines = function()
		return self.windowBounds.height - 2 - 2
	end function

	b.lastDisplayIndex = function()
		return self.firstDisplayIndex + self.maxDisplayLines - 1
	end function

	b.isAtTop = function()
		return self.firstDisplayIndex == 0
	end function

	b.isAtBottom = function(entity)
		return self.lastDisplayIndex >= entity.inventory.len - 1
	end function

	b.descriptionBounds = function()
		windowBounds = self.windowBounds
		return rect.make(windowBounds.centerX + 1, windowBounds.top + 1, windowBounds.width / 2 - 2, windowBounds.height - 2)
	end function

	b.describeItem = function(entity, item)
		windowBounds = self.descriptionBounds
		ui.clearRect(Display.hud, windowBounds, " ", color.clear, color.black)

		lineCount = ui.drawText(Display.hud, item.description, windowBounds)

		windowBounds.height -= lineCount + 1
		ui.drawText(Display.hud, "GP:" + item.goldValue, windowBounds, color.orange)
		windowBounds.height -= 1
		ui.drawText(Display.hud, "Weight:" + item.weight, windowBounds, color.orange)
		windowBounds.height -= 1
		ui.drawText(Display.hud, item.effectStr(), windowBounds, color.orange)

		windowBounds.height -= 1
		if self.isEquipped(entity, item) then
			ui.drawText(Display.hud, "Equipped.", windowBounds, color.green)
		else
			ui.drawText(Display.hud, "Not equipped.", windowBounds, color.yellow)
		end if
	end function

	b.isEquipped = function(entity, item)
		return (entity.weapon == item) or (entity.shield == item) or (entity.armor == item)
	end function

	b.drawInventoryLine = function(entity, inventoryIndex, isSelected)
		windowBounds = self.windowBounds
		item = entity.inventory[inventoryIndex]

		if isSelected then
			Display.hud.backColor = color.gray
			Display.hud.color = color.black
		else
			Display.hud.backColor = color.black
			Display.hud.color = color.gray
		end if

		Display.hud.row = windowBounds.bottom - 2 - inventoryIndex + self.firstDisplayIndex
		Display.hud.column = windowBounds.left + 1
		Display.hud.print(item.str())
		if self.isEquipped(entity, item) then
			Display.hud.print(" [E]")
		end if
	end function

	b.drawInventoryItems = function(entity)
		windowBounds = self.windowBounds
		ui.clearRect(Display.hud, rect.make(windowBounds.x + 1, windowBounds.y + 1, windowBounds.width / 2 - 1, windowBounds.height - 2), " ", color.clear, color.black)

		Display.hud.color = color.gray
		n = 1
		y = windowBounds.bottom - 1

		if not self.isAtTop then
			Display.hud.color = color.silver
		else
			Display.hud.color = "#444444"
		end if
		Display.hud.row = y
		Display.hud.column = windowBounds.left + 1
		Display.hud.backColor = color.black
		Display.hud.print("^" * (windowBounds.width / 2 - 1))
		y -= 1

		if entity.inventory.len == 0 then
			Display.hud.row = y
			Display.hud.column = windowBounds.left + 1
			Display.hud.print("You've got nothing.")
		else
			for n in range(self.firstDisplayIndex, self.lastDisplayIndex)
				if math.isInRange(n, 0, entity.inventory.len - 1) then
					self.drawInventoryLine(entity, n, self.selectedInventoryIndex == n)
				end if
				y -= 1
				n += 1
			end for
		end if

		if not self.isAtBottom(entity) then
			Display.hud.color = color.silver
		else
			// TODO: color.silver.dark
			Display.hud.color = "#444444"
		end if
		Display.hud.row = windowBounds.top + 1
		Display.hud.column = windowBounds.left + 1
		Display.hud.backColor = color.black
		Display.hud.print("v" * (windowBounds.width / 2 - 1))
	end function

	b.drawInventory = function(entity, title, description)
		windowBounds = self.windowBounds
		ui.drawWindow(Display.hud, windowBounds, title)
		ui.drawVerticalLine(Display.hud, windowBounds.centerX, windowBounds.top + 1, windowBounds.bottom - 1, ui.WINDOW_BORDER_FOREGROUND, ui.WINDOW_BORDER_BACKGROUND, "|")
		
		Display.hud.color = ui.WINDOW_BORDER_FOREGROUND
		Display.hud.row = windowBounds.top
		Display.hud.column = windowBounds.centerX
		Display.hud.print("+")
		
		Display.hud.backColor = color.black
		Display.hud.color = color.white
		Display.hud.row = windowBounds.bottom - 1
		Display.hud.column = windowBounds.left + 1
		Display.hud.print(description)

		self.drawInventoryItems(entity)

		self.describeItem(entity, entity.inventory[self.selectedInventoryIndex])
	end function

	b.eraseInventory = function()
		ui.clearRect(Display.hud, self.windowBounds, " ", color.clear, color.clear)
	end function

	b.selectInUI = function(entity, inventoryIndex)
		self.describeItem(entity, entity.inventory[self.selectedInventoryIndex])
		self.drawInventoryLine(entity, self.selectedInventoryIndex, true)
	end function

	b.scrollUp = function(entity)
		if not self.isAtTop then
			self.firstDisplayIndex -= 1
			self.drawInventoryItems(entity)
		end if
	end function

	b.scrollDown = function(entity)
		if not self.isAtBottom(entity) then
			self.firstDisplayIndex += 1
			self.drawInventoryItems(entity)
		end if
	end function

	// TODO: Merge useInventory and dropInventory loops.
	// TODO: Make the select list a reusable component.

	b.dropInventory = function(entity)
		self.firstDisplayIndex = 0
		self.selectedInventoryIndex = 0
		self.drawInventory(entity, "Drop Inventory Item", "")

		result = null
		while true
			delta = 0
			k = key.get.code
			if k == keybindings.up then
				delta = -1
			else if k == keybindings.down then
				delta = 1
			else if k == keybindings.exit then
				break
			else if k == keybindings.select then
				result = actions.dropInventoryItem(self.selectedInventoryIndex)
				break
			end if

			if delta != 0 then
				newIndex = math.clamp(self.selectedInventoryIndex + delta, 0, entity.inventory.len - 1)

				if newIndex < self.firstDisplayIndex then
					self.scrollUp(entity)
				else if newIndex > self.lastDisplayIndex then
					self.selectedInventoryIndex = newIndex
					self.scrollDown(entity)
				else
					if math.isInRange(newIndex, 0, entity.inventory.len - 1) then
						self.drawInventoryLine(entity, self.selectedInventoryIndex, false)
						self.selectedInventoryIndex = newIndex
						self.drawInventoryLine(entity, self.selectedInventoryIndex, true)
						self.selectInUI(entity, self.selectedInventoryIndex)
					end if
				end if

			end if
		end while

		self.eraseInventory()
		return result
	end function

	b.useInventory = function(entity)
		self.firstDisplayIndex = 0
		self.selectedInventoryIndex = 0
		self.drawInventory(entity, "Use Inventory Item", "")

		result = null
		while true
			delta = 0
			k = key.get.code
			if k == keybindings.up then
				delta = -1
			else if k == keybindings.down then
				delta = 1
			else if k == keybindings.exit then
				break
			else if k == keybindings.select then
				result = actions.useInventoryItem(self.selectedInventoryIndex)
				break
			end if

			if delta != 0 then
				newIndex = math.clamp(self.selectedInventoryIndex + delta, 0, entity.inventory.len - 1)

				if newIndex < self.firstDisplayIndex then
					self.scrollUp(entity)
				else if newIndex > self.lastDisplayIndex then
					self.selectedInventoryIndex = newIndex
					self.scrollDown(entity)
				else
					if math.isInRange(newIndex, 0, entity.inventory.len - 1) then
						self.drawInventoryLine(entity, self.selectedInventoryIndex, false)
						self.selectedInventoryIndex = newIndex
						self.drawInventoryLine(entity, self.selectedInventoryIndex, true)
						self.selectInUI(entity, self.selectedInventoryIndex)
					end if
				end if

			end if
		end while

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
				result = self.useInventory(entity)
			else if k == keybindings.drop then
				result = self.dropInventory(entity)
			else if k == keybindings.get then
				result = actions.pickUpItem(point.zero)
			else if k == keybindings.rest then
				result = self.healWhileResting(entity, map)
			end if
		end while

		return result
	end function
	
	return b
end function
