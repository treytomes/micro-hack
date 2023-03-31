Shield = new weapon.Weapon
Shield.armorClass = 0
Shield.damageDice = math.Dice.zero
Shield.tile = tile.make(")", Color.aqua, Color.black)

Shield.str = function()
	return self.name
	//if self.damageDice.numDice == 0 then
	//	return self.name + " (+" + self.armorClass + ")"
	//else
	//	return self.name + " (+" + self.armorClass + ", " + self.damageDice.str() + ")"
	//end if
end function

Shield.effectStr = function()
	text = "AC: " + self.armorClass
	if self.damageDice != math.Dice.zero then
		text += " Dmg:" + self.damageDice.str()
	end if
	return text
end function

Shield.use = function(entity)
	if entity.shield == self then
		entity.shield = null
	else
		entity.shield = self
	end if
end function
