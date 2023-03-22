Shield = new weapon.Weapon
Shield.armorClass = 0
Shield.damageDice = math.Dice.make(0, 0)
Shield.tile = tile.make(")", color.aqua, color.black)

// TODO: Every item needs a weight and gold value.

Shield.str = function()
	if self.damageDice.numDice == 0 then
		return self.name + " (+" + self.armorClass + ")"
	else
		return self.name + " (+" + self.armorClass + ", " + self.damageDice.str() + ")"
	end if
end function

Shield.use = function(entity)
	entity.shield = self
end function
