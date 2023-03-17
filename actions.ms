import "point"
import "sounds"
import "fov"

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
				Service.makeMessageParticles(entity.position.x, entity.position.y, delta, color.green)
			end if
		else
			entity.numRestTurns += 1
			//if entity.isPlayer then
			//	Service.messages.report("Rest turns=" + entity.numRestTurns)
			//end if
		end if
	end function
	return action
end function

walk = function(delta)
	action = new EntityAction
	action.delta = delta
	action.apply = function(entity, map)
		entity.numRestTurns = 0
		newPos = point.make(entity.position.x + self.delta.x, entity.position.y + self.delta.y)
		if map.tiles[newPos.y][newPos.x].blocksMovement then
			if entity.isPlayer then
				sounds.Sounds.pop()
			end if
		else
			bumpedEntity = map.getEntityAt(newPos)
			if bumpedEntity == null then
				entity.position = entity.position.add(self.delta)
				if entity.isPlayer then
					Service.fov.refresh(entity.position.x, entity.position.y, entity.rangeOfVision, map)
				end if
			else
				entity.onEntityCollision(bumpedEntity)
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
				Service.makeDamageParticles(self.targetEntity.position.x, self.targetEntity.position.y)
				entity.xp += self.targetEntity.xp
				Service.messages.report(entity.name + " earned " + self.targetEntity.xp + " XP.")
				self.targetEntity.xp = 0
			else
				Service.messages.report(entity.name + " attacks " + self.targetEntity.name + " : " + weaponDamage + ".")
				Service.makeMessageParticles(self.targetEntity.position.x, self.targetEntity.position.y, weaponDamage, color.red)
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