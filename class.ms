Class = {}
Class.name = "classless"
Class.hpDice = math.Dice.make(1, 10)
Class.dexterityDice = math.Dice.make(1, 20)
Class.strengthDice = math.Dice.make(1, 20)
Class.constitutionDie = math.Dice.make(3, 6)

Class.init = function(name, hpDice)
	self.name = name
	self.hpDice = hpDice
end function

Class.rollForStrength = function()
	return self.strengthDice.roll()
end function

Class.rollForDexterity = function()
	return self.dexterityDice.roll()
end function

Class.rollForHP = function()
	return self.hpDice.roll()
end function

Class.rollForConstitution = function()
	return self.constitutionDie.roll()
end function
