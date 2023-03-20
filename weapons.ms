Weapon = new items.Item
Weapon.damageDice = math.Dice.make(1, 1, 0)
Weapon.isConsumedOnUse = false

Weapon.str = function()
	return self.name + " (" + self.damageDice.str() + ")"
end function

Weapon.calculateWeaponDamage = function()
	return self.damageDice.roll()
end function

Weapon.use = function(entity)
	entity.weapon = self
end function

unarmed = new Weapon
unarmed.name = "unarmed"
unarmed.damageDice = math.Dice.make(1, 1)

// TODO: piercing damage, weight, dual-wield
dagger = new Weapon
dagger.tile = tile.make("-", color.gray, color.black)
dagger.name = "dagger"
dagger.damageDice = math.Dice.make(1, 4)

// TODO: piercing damage
shortSword = new Weapon
shortSword.tile = tile.make("\\", color.gray, color.black)
shortSword.name = "short sword"
shortSword.damageDice = math.Dice.make(1, 6)

// TODO: slashing damage
longSword = new Weapon
longSword.tile = tile.make("/", color.gray, color.black)
longSword.name = "long sword"
longSword.damageDice = math.Dice.make(1, 8)
