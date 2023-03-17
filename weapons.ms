import "math"

Weapon = {}
Weapon.name = "n/a"
Weapon.numDice = 1
Weapon.numSides = 1
Weapon.modifier = 0

Weapon.calculateWeaponDamage = function()
	return math.rollDice(self.numDice, self.numSides, self.modifier)
end function

unarmed = new Weapon
unarmed.name = "unarmed"
unarmed.numDie = 1
unarmed.numSides = 1

// TODO: piercing damage, weight, dual-wield
shortSword = new Weapon
shortSword.name = "short sword"
shortSword.numDie = 1
shortSword.numSides = 6

// TODO: slashing damage
longSword = new Weapon
longSword.name = "long sword"
longSword.numDie = 1
longSword.numSides = 8
