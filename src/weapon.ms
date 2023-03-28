Weapon = new item.Item
Weapon.damageDice = math.Dice.make(1, 1, 0)
Weapon.isConsumedOnUse = false

Weapon.str = function()
	return self.name // + " (" + self.damageDice.str() + ")"
end function

Weapon.calculateWeaponDamage = function()
	return self.damageDice.roll()
end function

Weapon.effectStr = function()
	return "Dmg:" + self.damageDice.str()
end function

Weapon.use = function(entity)
	if entity.weapon == self then
		entity.weapon = null
	else
		entity.weapon = self
	end if
end function
