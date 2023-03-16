import "actions"
import "point"
import "math"

Behavior = {}

Behavior.act = function()
	return actions.EntityAction.wait
end function

Behavior.onEntityCollision = function(sourceEntity, targetEntity)
end function

Behavior.makeAttackOnCollision = function()
	b = new Behavior

	b.attack = function(source, target)
		attackRoll = math.rollDice(1, 20)
		attackBonus = source.baseAttackBonus + source.strengthModifier
		if attackRoll + attackBonus >= target.armorClass then
			// Its a hit!
			weaponDamage = source.weaponDamage
			target.currentHP -= weaponDamage

			// Calculate entity death if necessary.
			if target.currentHP <= 0 then
				Service.messages.report(source.name + " attacks " + target.name + ", and it is dead.")
				Service.makeDamageParticles(target.position.x, target.position.y)
				source.xp += target.xp
				Service.messages.report(source.name + " earned " + target.xp + " XP.")
				target.xp = 0
			else
				Service.messages.report(source.name + " attacks " + target.name + " : " + weaponDamage + ".")
				Service.makeMessageParticles(target.position.x, target.position.y, weaponDamage, color.red)
			end if
			return true
		else
			// The attack misses.
			Service.messages.report(source.name + " attacks " + target.name + ", but misses.")
			return false
		end if
	end function

	b.onEntityCollision = function(sourceEntity, targetEntity)
		// Assume every entity has the fighter class.
		// Assume melee attacks.
		// Assume every entity is carrying a basic 1-handed short sword with damage of 1d8.
		
		if features.ALWAYS_COUNTER_ATTACK then
			// 1. Calculate initiative order.

			sourceInitiative = math.rollDice(1, 20) + sourceEntity.dexterityModifier
			targetInitiative = math.rollDice(1, 20) + targetEntity.dexterityModifier

			// 2. Highest initiative goes first.
			firstEntity = sourceEntity
			secondEntity = targetEntity
			if targetInitiative > sourceInitiative then
				firstEntity = targetEntity
				secondEntity = sourceEntity
			end if

			// 3. Attack roll.
			if not self.attack(firstEntity, secondEntity) then
				self.attack(secondEntity, firstEntity)
			end if
		else
			self.attack(sourceEntity, targetEntity)
		end if
	end function

	return b
end function

Behavior.makeRandomWalk = function()
	b = new Behavior
	b.currentDirection = point.Point.make(0, 0)

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

	b.wanderAround = function()
		if self.shouldChooseNewDirection() then
			self.chooseNewDirection()
		end if

		if self.currentDirection.x != 0 or self.currentDirection.y != 0 then
			return actions.EntityAction.walk(self.currentDirection) 
		else
			return actions.EntityAction.wait
		end if
	end function

	b.act = function(entity, map)
		return b.wanderAround()
	end function

	return b
end function

Behavior.makeSeekOutPlayer = function()
	b = Behavior.makeRandomWalk()

	b.act = function(entity, map)
		deltaX = sign(map.player.position.x - entity.position.x)
		deltaY = sign(map.player.position.y - entity.position.y)

		if deltaX ^ 2 + deltaY ^ 2 <= entity.rangeOfVision ^ 2 then
			// The entity can theoretically see the player.
			// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.

			if deltaX != 0 then
				if not map.blocksMovement(entity.position.x + deltaX, entity.position.y) then
					return actions.EntityAction.walk(point.make(deltaX, 0))
				end if
			else if deltaY != 0 then
				if not map.blocksMovement(entity.position.x, entity.position.y + deltaY) then
					return actions.EntityAction.walk(point.make(0, deltaY))
				end if
			end if
		end if

		return self.wanderAround()
	end function
	
	return b
end function

Behavior.makeUserInput = function()
	Keys = { "left": 17,
			"right": 18,
			"up": 19,
			"down": 20 }

	b = new Behavior

	b.act = function(entity, map)
		delta = point.Point.make(0, 0)
		k = key.get.code
		if k == Keys.up then
			delta.y = 1
		else if k == Keys.down then
			delta.y = -1
		else if k == Keys.left then
			delta.x = -1
		else if k == Keys.right then
			delta.x = 1
		end if

		if delta.x != 0 or delta.y != 0 then
			return actions.EntityAction.walk(delta)
		else
			return actions.EntityAction.wait
		end if
	end function
	
	return b
end function