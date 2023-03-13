import "actions"
import "point"
import "math"

Behavior = {}

Behavior.act = function()
	return actions.EntityAction.wait
end function

Behavior.attack = function(source, target)
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

Behavior.onEntityCollision = function(sourceEntity, targetEntity)
	// Assume every entity has the fighter class.
	// Assume melee attacks.
	// Assume every entity is carrying a basic 1-handed short sword with damage of 1d8.
	
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
end function

Behavior.makeRandomWalk = function()
	b = new Behavior
	b.currentDirection = point.Point.make(0, 0)

	b.chooseNewDirection = function(entity)
		dx = floor(rnd() * 3) - 1
		dy = 0
		if dx == 0 then
			dy = floor(rnd() * 3) - 1
		end if
		self.currentDirection.x = dx
		self.currentDirection.y = dy
	end function

	b.act = function(entity, map)
		action = actions.EntityAction.wait
		if rnd() > 0.5 then
			self.chooseNewDirection()
		end if

		if self.currentDirection.x != 0 or self.currentDirection.y != 0 then
			return actions.EntityAction.walk(self.currentDirection) 
		else
			return actions.EntityAction.wait
		end if
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