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
	e.inventory = []
	return e
end function

Entity.makePlayer = function(map)
	spawnPoint = map.findSpawnPoint()
	e = self.make(spawnPoint)
	e.isPlayer = true

	e.race = races.RaceDescriptions.human
	e.name = "player" //e.race.name
	e.class = classes.ClassDescriptions.fighter
	
	// Give the player some suff to start with.
	e.weapon = features.PLAYER_INITIAL_WEAPON
	for item in features.PLAYER_INITIAL_INVENTORY
		e.inventory.push(item)
	end for

	e.numRestTurns = 0
	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = e.class.rollForConstitution()
	e.maxHP = e.class.rollForHP() + e.constitutionModifier
	e.currentHP = e.maxHP
	e.perception = 8
	e.xp = 0

	e.behaviors.push(behaviors.Behavior.makeUserInput())
	e.behaviors.push(behaviors.Behavior.makeAttackOnCollision())
	return e
end function

Entity.makeKobold = function(map)
	spawnPoint = map.findHiddenSpawnPoint()

	e = self.make(spawnPoint)
	e.tile.foregroundColor = color.orange
	e.tile.char = "k";

	e.race = races.RaceDescriptions.kobold
	e.name = e.race.name
	e.class = classes.ClassDescriptions.fighter
	e.weapon = weapons.unarmed

	e.numRestTurns = 0
	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = 7
	e.maxHP = e.class.rollForHP() + e.constitutionModifier
	e.currentHP = e.maxHP

	// Reduced from 12 to 6.  They were just too hard with that much perception; along with the packing behavior.
	e.perception = 6 //12

	// You get this much XP for killing the monster.
	e.xp = 25

	e.behaviors.push(behaviors.Behavior.makeSeekPlayer())
	//e.behaviors.push(behaviors.Behavior.makeRandomWalk())
	e.behaviors.push(behaviors.Behavior.makeAttackOnCollision())
	return e
end function

Entity.draw = function(textDisplay, renderOffset)
	//self.tile.draw(self.position.x, self.position.y)
	x = renderOffset.x + self.position.x
	y = renderOffset.y + self.position.y

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

Entity.modifyHP = function(amount)
	oldHP = self.currentHP
	self.currentHP += amount
	if self.currentHP < 0 then
		self.currentHP = 0
	else if self.currentHP > self.maxHP then
		self.currentHP = self.maxHP
	end if
	return self.currentHP - oldHP
end function

Entity.isAlive = function()
	return self.currentHP > 0
end function

Entity.isDead = function()
	return self.currentHP <= 0
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
	return self.weapon.calculateWeaponDamage()
end function

Entity.rangeOfVision = function()
	return self.perception
end function

Entity.level = function()
	return 1 + floor(log((self.xp / 300) + 1, 2))
end function

// How much XP is needed to reach the next level?
Entity.xpToNextLevel = function()
	return 300 * (2 ^ self.level - 1)
end function