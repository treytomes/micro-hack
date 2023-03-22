Weapon = new item.Item
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
