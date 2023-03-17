import "math"
import "items"

Weapon = new items.Item
Weapon.damageDice = math.Dice.make(1, 1, 0)
Weapon.isConsumedOnUse = false

Weapon.str = function()
	return self.name + " (" + self.damageDice.str() + ")"
end function

Weapon.calculateWeaponDamage = function()
	return self.damageDice.roll()
end function

unarmed = new Weapon
unarmed.name = "unarmed"
unarmed.damageDice = math.Dice.make(1, 1)

// TODO: piercing damage, weight, dual-wield
dagger = new Weapon
dagger.name = "dagger"
dagger.damageDice = math.Dice.make(1, 4)

// TODO: piercing damage
shortSword = new Weapon
shortSword.name = "short sword"
shortSword.damageDice = math.Dice.make(1, 6)

// TODO: slashing damage
longSword = new Weapon
longSword.name = "long sword"
longSword.damageDice = math.Dice.make(1, 8)
