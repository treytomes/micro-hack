Entity = {}

Entity.init = function(pnt=null)
	self.tile = tile.make("@", color.white, color.black, true, false)
	self.position = pnt
	self.isPlayer = false
	self.behaviors = []
	self.inventory = []
	self.canBeAttacked = true
	self.numRestTurns = 0

	self.race = null
	self.name = null
	self.class = null
	self.weapon = null
	self.armor = null
	self.shield = null

	self.dexterity = 0
	self.strength = 0
	self.constitution = 0
	self.maxHP = 1
	self.currentHP = 1
	self.perception = 0
	self.xp = 0

	return self
end function

Entity.canSee = function(pnt)
	// TODO: I could use the fov calculateLineOfSight function to check for blockers.
	deltaX = pnt.x - self.position.x
	deltaY = pnt.y - self.position.y
	return deltaX ^ 2 + deltaY ^ 2 <= self.rangeOfVision ^ 2
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
	dmg = math.coalesce(self.weapon, weapons.unarmed).calculateWeaponDamage()
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
	hpDelta = self.class.hpDice.roll() + self.constitutionModifier
	self.maxHP += hpDelta
	//self.currentHP += hpDelta
	self.modifyHP(hpDelta)

	// TODO: This is where abilities and proficiencies will be increased.
end function

Entity.isEquipped = function(item)
	return (self.weapon == item) or (self.shield == item) or (self.armor == item)
end function

// If the item is equipped in any way, un-equip it.
Entity.removeFromSlots = function(item)
	if self.weapon == item then
		self.weapon = null
	else if self.shield == item then
		self.shield = null
	else if self.armor == item then
		self.armor = null
	end if
end function