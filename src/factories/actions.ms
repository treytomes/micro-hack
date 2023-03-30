ensureImport "sounds"

EntityAction = {}

wait = function()
	action = new EntityAction
	action.apply = function(entity, map)
		if features.REST_HP_ROLL then
			oldHP = entity.currentHP
			recoveredHP = entity.class.rollForHP()
			entity.currentHP += recoveredHP
			if entity.currentHP > entity.maxHP then
				entity.currentHP = entity.maxHP
			end if
			delta = entity.currentHP - oldHP
			if delta != 0 then
				Service.makeMessageParticles(entity.position, delta, Color.green)
			end if
		else
			entity.numRestTurns += 1
		end if
	end function
	return action
end function

walk = function(delta)
	action = new EntityAction
	action.delta = delta

	action.apply = function(entity, map)
		entity.numRestTurns = 0
		//newPos = entity.position + self.delta
		newPos = point.make(entity.position.x + self.delta.x, entity.position.y + self.delta.y)
		if map.tiles[newPos.y][newPos.x].blocksMovement then
			if entity.isPlayer then
				sounds.pop()
			end if
		else
			bumpedEntity = map.getEntityAt(newPos) 
			if bumpedEntity == null or (not bumpedEntity.canBeAttacked and not bumpedEntity.tile.blocksMovement) then
				entity.position = entity.position.add(self.delta)
				if entity.isPlayer then
					Service.fov.refresh(entity.position.x, entity.position.y, entity.rangeOfVision, map)

					if entity.isPlayer and bumpedEntity != null and bumpedEntity.hasIndex("item") then
						Service.messages.report("You see a " + bumpedEntity.name + " there.")
					end if
				end if
			else
				entity.onEntityCollision(bumpedEntity, map)
			end if
		end if
	end function
	return action
end function

useInventoryItem = function(inventoryIndex)
	action = new EntityAction
	action.inventoryIndex = inventoryIndex
	action.apply = function(entity, map)
		item = entity.inventory[inventoryIndex]
		item.use(entity)
		if item.isConsumedOnUse then
			entity.inventory.remove(inventoryIndex)
		end if

		Service.messages.report(entity.name + " used " + item.name + ".")
	end function
	return action
end function

dropInventoryItem = function(inventoryIndex)
	action = new EntityAction
	action.inventoryIndex = inventoryIndex
	action.apply = function(entity, map)
		item = entity.inventory[self.inventoryIndex]
		
		itemEntity = entities.makeItem(map, item, entity.position)
		map.entities.push(itemEntity)
		Service.messages.report(entity.name + " dropped " + item.name + ".")

		entity.removeFromSlots(item)
		entity.inventory.remove(self.inventoryIndex)
	end function
	return action
end function

pickUpItem = function(delta)
	action = new EntityAction
	action.delta = delta

	action.pickUpItem = function(entity, map, itemEntity)
		map.removeEntity(itemEntity)
		entity.inventory.push(itemEntity.item)
		Service.messages.report(entity.name + " picked up a " + itemEntity.name + ".")
	end function

	action.apply = function(entity, map)
		entities = map.getEntitiesAt(entity.position.add(self.delta))
		for e in entities
			if e == entity then
				continue
			else if e.hasIndex("item") then
				self.pickUpItem(entity, map, e)
				return
			end if
		end for
	end function
	return action
end function

attack = function(targetEntity)
	action = new EntityAction
	action.targetEntity = targetEntity
	action.apply = function(entity, map)
		attackRoll = math.Dice.make(1, 20).roll()
		attackBonus = entity.baseAttackBonus + entity.strengthModifier
		if attackRoll + attackBonus >= self.targetEntity.armorClass then
			// Its a hit!
			weaponDamage = entity.weaponDamage
			self.targetEntity.modifyHP(-weaponDamage)

			// Calculate entity death if necessary.
			if self.targetEntity.isDead then
				Service.messages.report(entity.name + " attacks " + self.targetEntity.name + ", and it is dead.")
				Service.makeDeathParticles(self.targetEntity.position)
				entity.modifyXP(self.targetEntity.xp)
				self.targetEntity.xp = 0
				self.targetEntity.onDeath(entity, map)
			else
				Service.messages.report(entity.name + " attacks " + self.targetEntity.name + " : " + weaponDamage + ".")
			end if
			return true
		else
			// The attack misses.
			Service.messages.report(entity.name + " attacks " + self.targetEntity.name + ", but misses.")
			return false
		end if
	end function
	return action
end function

takeStairsUp = function()
	action = new EntityAction
	action.apply = function(entity, map)
		if Service.world.currentLevel > 0 then
			Service.world.player.leaveMap(Service.world.map)
			Service.world.currentLevel -= 1
			Service.world.player.enterMap(Service.world.map, false)
		end if
	end function
	return action
end function

takeStairsDown = function()
	action = new EntityAction
	action.apply = function(entity, map)
		Service.world.player.leaveMap(Service.world.map)
		Service.world.currentLevel += 1
		Service.world.player.enterMap(Service.world.map, true)
	end function
	return action
end function
