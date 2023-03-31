Entity = new Object

Entity.init = function(tile, race, class, pnt=null)
	super.init()
	
	self.tile = tile
	self.position = pnt
	self.isPlayer = false
	self.behaviors = []
	self.inventory = []
	self.canBeAttacked = true
	self.numRestTurns = 0

	self.race = race
	self.class = class
	if self.race != null then self.name = self.race.name else self.name = "N/A"

	self.strength = self.race.strength.roll() + self.class.strength.roll()
	self.dexterity = self.race.dexterity.roll() + self.class.dexterity.roll()
	self.constitution = self.race.constitution.roll() + self.class.constitution.roll()
	self.intelligence = self.race.intelligence.roll() + self.class.intelligence.roll()
	self.wisdom = self.race.wisdom.roll() + self.class.wisdom.roll()
	self.charisma = self.race.charisma.roll() + self.class.charisma.roll()
	
	self.maxHP = self.race.hp.roll() + self.class.hp.roll() + self.constitutionModifier
	self.currentHP = self.maxHP

	self.xp = 0

	self.weapon = null
	self.armor = null
	self.shield = null

	return self
end function

Entity.canSee = function(pnt)
	// TODO: I could use the fov calculateLineOfSight function to check for blockers.
	deltaX = pnt.x - self.position.x
	deltaY = pnt.y - self.position.y
	return deltaX * deltaX + deltaY * deltaY <= self.rangeOfVision * self.rangeOfVision
end function

Entity.draw = function(textDisplay, renderOffset)
	//self.tile.draw(self.position.x, self.position.y)
	x = renderOffset.x + self.position.x
	y = renderOffset.y + self.position.y

	colorMod = self.currentHP / self.maxHP
	foregroundColor = Color.lerp(Color.red, self.tile.foregroundColor, colorMod)
	textDisplay.setCellColor x, y, foregroundColor.str()
	textDisplay.setCellBackColor x, y, self.tile.backgroundColor.str()
	textDisplay.setCell x, y, self.tile.char
end function

Entity.act = function(map)
	for b in self.behaviors
		a = b.act(self, map)
		if a != actions.wait then
			return a
		end if
	end for
	return actions.wait()
end function

Entity.onDeath = function(killedByEntity, map)
	// Drop some loot.
	while self.inventory.len > 0
		actions.dropInventoryItem(0).apply(self, map)
	end while
end function

// Complete process a collision between 2 entities.
Entity.onEntityCollision = function(bumpedEntity, map)
	for b in self.behaviors
		b.onEntityCollision(self, bumpedEntity, map)
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

	delta = self.currentHP - oldHP

	if delta > 0 then	
		Service.messages.report(self.name + " was healed by " + delta + " HP.")
		Service.makeMessageParticles(self.position, delta, Color.green)
	else if delta < 0 then
		Service.makeMessageParticles(self.position, -delta, Color.red)
	end if

	return self.currentHP - oldHP
end function

Entity.isAlive = function()
	return self.currentHP > 0
end function

Entity.isDead = function()
	return self.currentHP <= 0
end function

Entity.wisdomModifier = function()
	return floor((self.wisdom - 10) / 2)
end function

Entity.perception = function()
	return 10 + self.wisdomModifier
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
	ac = self.race.baseArmorClass + self.dexterityModifier
	if self.shield != null then
		ac += self.shield.armorClass
	end if
	if self.armor != null then
		ac += self.armor.armorClass
	end if
	return ac
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
	if self.weapon == null then
		dmg = 1
	else
		dmg = self.weapon.calculateWeaponDamage()
	end if
	if self.shield != null then
		dmg += self.shield.calculateWeaponDamage()
	end if
	return dmg
end function

// This formula may need to be tweaked later, when perception has more uses attached.
Entity.rangeOfVision = function()
	return self.perception
end function

Entity.level = function()
	return 1 + floor(log(self.xp / 300 + 1, 2))
end function

// How much XP is needed to reach the next level?
Entity.xpToNextLevel = function()
	return 300 * (2 ^ self.level - 1)
end function

Entity.modifyXP = function(amount)
	oldLevel = self.level
	self.xp += amount
	Service.messages.report("{0} earned {1} XP.".fill([ self.name, amount]))
	if self.level != oldLevel then
		self.levelUp()
	end if
end function

Entity.levelUp = function()
	Service.makeLevelUpParticles(self.position)
	Service.messages.report("{0} has leveled up!".fill([ self.name ]))
	hpDelta = self.class.hp.roll() + self.constitutionModifier
	self.maxHP += hpDelta
	//self.currentHP += hpDelta
	self.modifyHP(hpDelta)

	// TODO: This is where abilities and proficiencies will be increased.
end function

Entity.isEquipped = function(item)
	return (self.weapon != null and self.weapon.equals(item)) or (self.shield != null and self.shield.equals(item)) or (self.armor != null and self.armor.equals(item))
end function

// If the item is equipped in any way, un-equip it.
Entity.removeFromSlots = function(item)
	if self.weapon != null and self.weapon.equals(item) then
		self.weapon = null
	else if self.shield != null and self.shield.equals(item) then
		self.shield = null
	else if self.armor != null and self.armor.equals(item) then
		self.armor = null
	end if
end function