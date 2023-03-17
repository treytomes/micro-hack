import "math"

Weapon = {}
Weapon.name = "n/a"
Weapon.dice = math.Dice.make(1, 1, 0)

Weapon.str = function()
	return self.name + " (" + self.dice.str() + ")"
end function

Weapon.calculateWeaponDamage = function()
	return self.dice.roll()
end function

unarmed = new Weapon
unarmed.name = "unarmed"
unarmed.dice = math.Dice.make(1, 1)

// TODO: piercing damage, weight, dual-wield
shortSword = new Weapon
shortSword.name = "short sword"
shortSword.dice = math.Dice.make(1, 6)

// TODO: slashing damage
longSword = new Weapon
longSword.name = "long sword"
longSword.dice = math.Dice.make(1, 8)
