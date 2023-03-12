import "actions"
import "point"
import "tile"

Entity = {}

Entity.make = function(pnt)
	e = new Entity
	e.tile = tile.Tile.make("@", color.white, color.black, false, false)
	e.position = pnt
	e.isPlayer = false
	e.behaviors = []
	return e
end function

Entity.draw = function(textDisplay)
	//self.tile.draw(self.position.x, self.position.y)
	x = self.position.x
	y = self.position.y

	colorMod = self.currentHP / self.maxHP
	foregroundColor = color.lerp(color.red, self.tile.foregroundColor, colorMod)
	textDisplay.setCellColor x, y, foregroundColor
	textDisplay.setCellBackColor x, y, self.tile.backgroundColor
	textDisplay.setCell x, y, self.tile.char
end function

Entity.act = function(map)
	for b in self.behaviors
		action = b.act(self, map)
		if action != actions.EntityAction.wait then
			return action
		end if
	end for
	return actions.EntityAction.wait
end function

// Complete process a collision between 2 entities.
Entity.onEntityCollision = function(bumpedEntity)
	for b in self.behaviors
		b.onEntityCollision(self, bumpedEntity)
	end for
end function

Entity.constitutionModifier = function()
	return floor((self.constitution - 10) / 2)
end function

Entity.dexterityModifier = function()
	return floor((self.dexterity - 10) / 2)
end function

Entity.strengthModifier = function()
	return floor((self.strength - 10) / 2)
end function

Entity.armorClass = function()
	return self.race.baseArmorClass + self.dexterityModifier
end function

Entity.baseAttackBonus = function()
	return self.level + 1
end function

Entity.maxCarryingCapacity = function()
	return self.strength * 15
end function

Entity.maxPushCapacity = function()
	return self.strength * 30
end function

Entity.weaponDamage = function()
	return self.weapon.rollDice()
end function